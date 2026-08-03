import SwiftUI
import FirebaseAuth
import FirebaseFirestore

// MARK: - Modelo de Género
enum Genero {
    case hombre, mujer

    var imagenNombre: String {
        switch self {
        case .hombre: return "perfil boy"
        case .mujer:  return "perfil"
        }
    }

    var etiqueta: String {
        switch self {
        case .hombre: return "Hombre"
        case .mujer:  return "Mujer"
        }
    }

    var textoGuardado: String {
        switch self {
        case .hombre: return "hombre"
        case .mujer:  return "mujer"
        }
    }

    // ── Color por género ──
    var colorPrincipal: Color {
        switch self {
        case .hombre: return Color(red: 0.20, green: 0.50, blue: 1.00)
        case .mujer:  return Color(red: 0.47, green: 0.38, blue: 0.93)
        }
    }
}

// MARK: - Vista Principal
struct CrearCuentaView: View {

    @Environment(\.dismiss) var dismiss

    @State private var nombre:             String  = ""
    @State private var correo:             String  = ""
    @State private var contrasena:         String  = ""
    @State private var mostrarContrasena:  Bool    = false
    @State private var generoSeleccionado: Genero? = nil
    @State private var mostrarExito:       Bool    = false
    @State private var errorMensaje:       String  = ""
    @State private var mostrarError:       Bool    = false
    @State private var cargando:           Bool    = false

    var body: some View {
        ZStack {
            // ── Fondo con gradiente suave ──
            LinearGradient(
                colors: [
                    Color(red: 0.97, green: 0.96, blue: 1.00),
                    Color(red: 0.93, green: 0.95, blue: 1.00)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // ── Círculos decorativos de fondo ──
            Circle()
                .fill(Color(red: 0.47, green: 0.38, blue: 0.93).opacity(0.08))
                .frame(width: 300, height: 300)
                .offset(x: 130, y: -200)

            Circle()
                .fill(Color(red: 0.20, green: 0.50, blue: 1.00).opacity(0.07))
                .frame(width: 250, height: 250)
                .offset(x: -120, y: 350)

            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 22) {

                        // ── Encabezado ──
                        VStack(spacing: 6) {
                            Text("Crear Cuenta")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.47, green: 0.38, blue: 0.93),
                                            Color(red: 0.20, green: 0.50, blue: 1.00)
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                            Text("Rellena tus datos para empezar")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 24)
                        .padding(.bottom, 4)

                        // ── Nombre ──
                        campoTexto(
                            titulo: "Nombre",
                            placeholder: "Daniel",
                            texto: $nombre,
                            icono: "person.fill"
                        )

                        // ── Correo ──
                        campoTexto(
                            titulo: "Correo",
                            placeholder: "correo@email.com",
                            texto: $correo,
                            icono: "envelope.fill",
                            esEmail: true
                        )

                        // ── Contraseña ──
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Contraseña", systemImage: "lock.fill")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(red: 0.30, green: 0.30, blue: 0.40))

                            HStack {
                                if mostrarContrasena {
                                    TextField("Mínimo 6 caracteres", text: $contrasena)
                                } else {
                                    SecureField("Mínimo 6 caracteres", text: $contrasena)
                                }
                                Button {
                                    mostrarContrasena.toggle()
                                } label: {
                                    Image(systemName: mostrarContrasena ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(.gray.opacity(0.5))
                                        .font(.system(size: 14))
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
                        }

                        // ── Género ──
                        VStack(alignment: .leading, spacing: 14) {
                            Label("Género", systemImage: "person.2.fill")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(red: 0.30, green: 0.30, blue: 0.40))

                            HStack(spacing: 16) {
                                botonGenero(.hombre)
                                botonGenero(.mujer)
                            }
                        }

                        // ── Mensaje de error ──
                        if mostrarError {
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundColor(.red)
                                Text(errorMensaje)
                                    .font(.system(size: 13))
                                    .foregroundColor(.red)
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(Color.red.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .transition(.scale.combined(with: .opacity))
                        }

                        Spacer(minLength: 8)

                        // ── Botón Crear Cuenta ──
                        Button {
                            crearCuenta()
                        } label: {
                            ZStack {
                                Text("Crear Cuenta")
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundColor(.white)
                                    .opacity(cargando ? 0 : 1)

                                if cargando {
                                    ProgressView()
                                        .tint(.white)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.47, green: 0.38, blue: 0.93),
                                        Color(red: 0.60, green: 0.52, blue: 1.00)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(
                                color: Color(red: 0.47, green: 0.38, blue: 0.93).opacity(0.4),
                                radius: 12, x: 0, y: 6
                            )
                        }
                        .disabled(cargando)
                        .padding(.bottom, 28)
                    }
                    .padding(.horizontal, 24)
                }
                #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif
            }
            .disabled(mostrarExito)
            .blur(radius: mostrarExito ? 6 : 0)

            // ── POPUP ÉXITO ──
            if mostrarExito {
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                    .transition(.opacity)

                VStack(spacing: 20) {
                    if let genero = generoSeleccionado {
                        ZStack {
                            Circle()
                                .fill(genero.colorPrincipal.opacity(0.12))
                                .frame(width: 160, height: 160)
                            Image(genero.imagenNombre)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 140, height: 140)
                                .clipShape(Circle())
                        }
                        .padding(.top, 10)
                    }

                    VStack(spacing: 6) {
                        Text("¡Enhorabuena! ")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.black)
                        Text("Tu cuenta se creó con éxito")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }

                    Button {
                        withAnimation { mostrarExito = false }
                        dismiss()
                    } label: {
                        Text("Iniciar Sesión")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.47, green: 0.38, blue: 0.93),
                                        Color(red: 0.60, green: 0.52, blue: 1.00)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .shadow(
                                color: Color(red: 0.47, green: 0.38, blue: 0.93).opacity(0.35),
                                radius: 10, x: 0, y: 5
                            )
                    }
                }
                .padding(28)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 28))
                .shadow(color: Color.black.opacity(0.15), radius: 30, x: 0, y: 10)
                .padding(.horizontal, 28)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: mostrarError)
    }

    // MARK: - Firebase
    private func crearCuenta() {
        guard !nombre.isEmpty else {
            mostrarErrorMsg("Por favor escribe tu nombre")
            return
        }
        guard !correo.isEmpty else {
            mostrarErrorMsg("Por favor escribe tu correo")
            return
        }
        guard contrasena.count >= 6 else {
            mostrarErrorMsg("La contraseña debe tener al menos 6 caracteres")
            return
        }
        guard let genero = generoSeleccionado else {
            mostrarErrorMsg("Por favor selecciona tu género")
            return
        }

        cargando = true
        mostrarError = false

        Auth.auth().createUser(withEmail: correo, password: contrasena) { resultado, error in
            if let error = error {
                cargando = false
                mostrarErrorMsg(traducirError(error))
                return
            }

            guard let uid = resultado?.user.uid else { return }

            let db = Firestore.firestore()
            db.collection("usuarios").document(uid).setData([
                "nombre": nombre,
                "correo": correo,
                "genero": genero.textoGuardado,
                "memoji": genero.imagenNombre,
                "fechaRegistro": Timestamp(date: Date())
            ]) { error in
                cargando = false
                if let error = error {
                    mostrarErrorMsg(traducirError(error))
                    return
                }
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    mostrarExito = true
                }
            }
        }
    }

    private func traducirError(_ error: Error) -> String {
        let codigo = (error as NSError).code
        switch codigo {
        case 17007: return "Este correo ya está registrado"
        case 17008: return "El formato del correo no es válido"
        case 17026: return "La contraseña debe tener al menos 6 caracteres"
        case 17009: return "La contraseña es incorrecta"
        case 17011: return "No existe una cuenta con este correo"
        case 17010: return "Demasiados intentos, intenta más tarde"
        default:    return "Ocurrió un error, intenta de nuevo"
        }
    }

    private func mostrarErrorMsg(_ mensaje: String) {
        errorMensaje = mensaje
        mostrarError = true
    }

    // MARK: - Helpers
    @ViewBuilder
    private func campoTexto(
        titulo: String,
        placeholder: String,
        texto: Binding<String>,
        icono: String,
        esEmail: Bool = false
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(titulo, systemImage: icono)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(red: 0.30, green: 0.30, blue: 0.40))

            TextField(placeholder, text: texto)
                #if os(iOS)
                .keyboardType(esEmail ? .emailAddress : .default)
                .textInputAutocapitalization(esEmail ? .never : .words)
                #endif
                .autocorrectionDisabled(esEmail)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
        }
    }

    @ViewBuilder
    private func botonGenero(_ genero: Genero) -> some View {
        let seleccionado = generoSeleccionado == genero
        let colorGenero  = genero.colorPrincipal

        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                generoSeleccionado = genero
            }
        } label: {
            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(seleccionado
                              ? colorGenero.opacity(0.12)
                              : Color.gray.opacity(0.07))
                        .frame(width: 110, height: 110)

                    Image(genero.imagenNombre)
                        .resizable()
                        .scaledToFit()
                        .frame(width: genero == .mujer ? 105 : 88)
                }

                Text(genero.etiqueta)
                    .font(.system(size: 14, weight: seleccionado ? .bold : .medium))
                    .foregroundColor(seleccionado ? colorGenero : .gray)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 7)
                    .background(
                        seleccionado
                            ? colorGenero.opacity(0.12)
                            : Color.gray.opacity(0.10)
                    )
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(
                                seleccionado ? colorGenero.opacity(0.5) : Color.clear,
                                lineWidth: 1.5
                            )
                    )
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(
                color: seleccionado
                    ? colorGenero.opacity(0.25)
                    : Color.black.opacity(0.05),
                radius: seleccionado ? 12 : 6,
                x: 0, y: seleccionado ? 6 : 2
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        seleccionado ? colorGenero.opacity(0.4) : Color.clear,
                        lineWidth: 1.5
                    )
            )
            .scaleEffect(seleccionado ? 1.03 : 1.0)
        }
    }
}

// MARK: - Preview
#Preview {
    CrearCuentaView()
}
