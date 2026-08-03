import Foundation
import FirebaseAuth
import FirebaseFirestore

struct FraseGuardada: Identifiable, Codable, Equatable {
    var id: String
    let frase: String
    let etiqueta: String
    let estado: String
    let fecha: Date

    init(id: String = UUID().uuidString, frase: String, etiqueta: String, estado: String, fecha: Date = Date()) {
        self.id = id
        self.frase = frase
        self.etiqueta = etiqueta
        self.estado = estado
        self.fecha = fecha
    }

    init?(dict: [String: Any]) {
        guard let frase = dict["frase"] as? String,
              let etiqueta = dict["etiqueta"] as? String,
              let estado = dict["estado"] as? String else { return nil }
        self.id = dict["id"] as? String ?? UUID().uuidString
        self.frase = frase
        self.etiqueta = etiqueta
        self.estado = estado
        if let ts = dict["fecha"] as? Timestamp {
            self.fecha = ts.dateValue()
        } else {
            self.fecha = Date()
        }
    }

    var diccionario: [String: Any] {
        [
            "id": id,
            "frase": frase,
            "etiqueta": etiqueta,
            "estado": estado,
            "fecha": Timestamp(date: fecha)
        ]
    }
}

struct DatosPerfil {
    var nombre: String
    var correo: String
    var genero: String
    var diasActivos: Int
    var frasesGuardadas: [FraseGuardada]
    var fechaRegistro: Date?
}

enum UsuarioService {

    private static let db = Firestore.firestore()

    static var uid: String? { Auth.auth().currentUser?.uid }
    static var correoActual: String { Auth.auth().currentUser?.email ?? "" }

    // MARK: - UserDefaults (preferencias locales)
    private static let prefIdioma = "app_idioma"

    static var idioma: String {
        get { UserDefaults.standard.string(forKey: prefIdioma) ?? "es" }
        set { UserDefaults.standard.set(newValue, forKey: prefIdioma) }
    }

    // MARK: - Hábitos del día
    private static let prefHabitosDia = "habitos_completados_dia"
    private static let totalHabitos = 8

    static var totalHabitosDisponibles: Int { totalHabitos }

    private static func fechaHoyString() -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: Date())
    }

    static func habitosCompletadosHoy() -> Set<String> {
        guard let data = UserDefaults.standard.dictionary(forKey: prefHabitosDia),
              let fecha = data["fecha"] as? String,
              fecha == fechaHoyString(),
              let ids = data["ids"] as? [String] else { return [] }
        return Set(ids)
    }

    static func marcarHabito(_ id: String, completado: Bool) {
        var ids = habitosCompletadosHoy()
        if completado {
            ids.insert(id)
        } else {
            ids.remove(id)
        }
        UserDefaults.standard.set(
            ["fecha": fechaHoyString(), "ids": Array(ids)],
            forKey: prefHabitosDia
        )
    }

    static var cantidadHabitosHoy: Int { habitosCompletadosHoy().count }

    // MARK: - Cargar perfil
    static func cargarPerfil(completion: @escaping (Result<DatosPerfil, Error>) -> Void) {
        guard let uid = uid else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Sin sesión"])))
            return
        }
        db.collection("usuarios").document(uid).getDocument { doc, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            let data = doc?.data() ?? [:]
            let nombre = data["nombre"] as? String ?? "Usuario"
            let genero = data["genero"] as? String ?? "mujer"
            let correo = data["correo"] as? String ?? correoActual
            let fechaReg = (data["fechaRegistro"] as? Timestamp)?.dateValue()

            let frasesRaw = data["frasesGuardadas"] as? [[String: Any]] ?? []
            let frases = frasesRaw.compactMap { FraseGuardada(dict: $0) }

            var dias = 1
            if let fechaReg {
                let cal = Calendar.current
                let inicio = cal.startOfDay(for: fechaReg)
                let hoy = cal.startOfDay(for: Date())
                dias = max(1, (cal.dateComponents([.day], from: inicio, to: hoy).day ?? 0) + 1)
            }

            completion(.success(DatosPerfil(
                nombre: nombre,
                correo: correo,
                genero: genero,
                diasActivos: dias,
                frasesGuardadas: frases,
                fechaRegistro: fechaReg
            )))
        }
    }

    // MARK: - Actualizar nombre
    static func actualizarNombre(_ nombre: String, completion: @escaping (Error?) -> Void) {
        guard let uid = uid else {
            completion(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Sin sesión"]))
            return
        }
        db.collection("usuarios").document(uid).updateData(["nombre": nombre]) { error in
            completion(error)
        }
    }

    // MARK: - Frases guardadas
    static func guardarFrase(_ frase: FraseGuardada, completion: @escaping (Error?) -> Void) {
        guard let uid = uid else {
            completion(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Sin sesión"]))
            return
        }
        let ref = db.collection("usuarios").document(uid)
        ref.getDocument { doc, error in
            if let error = error {
                completion(error)
                return
            }
            var lista = (doc?.data()?["frasesGuardadas"] as? [[String: Any]] ?? [])
                .compactMap { FraseGuardada(dict: $0) }
            if lista.contains(where: { $0.frase == frase.frase }) {
                completion(nil)
                return
            }
            lista.insert(frase, at: 0)
            ref.updateData(["frasesGuardadas": lista.map { $0.diccionario }]) { error in
                completion(error)
            }
        }
    }

    static func eliminarFrase(id: String, completion: @escaping (Error?) -> Void) {
        guard let uid = uid else {
            completion(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Sin sesión"]))
            return
        }
        let ref = db.collection("usuarios").document(uid)
        ref.getDocument { doc, error in
            if let error = error {
                completion(error)
                return
            }
            var lista = (doc?.data()?["frasesGuardadas"] as? [[String: Any]] ?? [])
                .compactMap { FraseGuardada(dict: $0) }
            lista.removeAll { $0.id == id }
            ref.updateData(["frasesGuardadas": lista.map { $0.diccionario }]) { error in
                completion(error)
            }
        }
    }

    // MARK: - Cerrar sesión
    static func cerrarSesion() throws {
        try Auth.auth().signOut()
    }
}
