// ─────────────────────────────────────────────────────────────
// MENU VIEW PREMIUM COMPLETADO Y TOTALMENTE COMPATIBLE
// ─────────────────────────────────────────────────────────────

import SwiftUI

struct MenuView: View {

    @State private var nombreUsuario: String
    let genero: String
    var onCerrarSesion: () -> Void

    // MARK: ─── ESTADOS ─────────────────────────────

    @State private var tabActual = 0
    @State private var animarInicio = false
    @State private var estadoSeleccionado: String = ""
    @State private var diasActivos: [Bool] = Array(repeating: false, count: 7)

    // COLORES (Apple Minimal / Premium)
    private let morado1 = Color(red: 123/255, green: 92/255, blue: 255/255)
    private let morado2 = Color(red: 88/255,  green: 60/255, blue: 220/255)
    private let fondo   = Color(red: 247/255, green: 247/255, blue: 252/255)

    // MARK: ─── INIT ─────────────────────────────

    init(
        nombreUsuario: String,
        genero: String,
        onCerrarSesion: @escaping () -> Void = {}
    ) {
        _nombreUsuario = State(initialValue: nombreUsuario)
        self.genero = genero
        self.onCerrarSesion = onCerrarSesion
    }

    // MARK: ─── COMPONENTES CALCULADOS ─────────────────────────────

    var saludoHora: String {
        let hora = Calendar.current.component(.hour, from: Date())
        switch hora {
        case 5..<12:  return "Buenos días ☀️"
        case 12..<19: return "Buenas tardes 🌤"
        default:      return "Buenas noches 🌙"
        }
    }

    var diasSemana: [String] { ["L","M","M","J","V","S","D"] }

    var diasCompletados: Int {
        diasActivos.filter { $0 }.count
    }

    let actividades: [(String, String, String)] = [
        ("Ejercicio",  "Libera tensión",    "imagen correr"),
        ("Meditación", "Relaja tu mente",   "imagen meditar"),
        ("Música",     "Respira con calma", "imagen musica")
    ]

    // MARK: ─── BODY PRINCIPAL ─────────────────────────────

    var body: some View {
        Group {
            switch tabActual {
            case 0: vistaInicio
            case 1:
                HabitosView(
                    nombreUsuario: nombreUsuario,
                    memojiNombre: genero == "hombre" ? "perfil boy" : "perfil"
                )
            case 2:
                ChatbotView(
                    tabActual: $tabActual,
                    nombreUsuario: nombreUsuario,
                    genero: genero
                )
            case 3:
                FrasesView(nombreUsuario: nombreUsuario, genero: genero)
            case 4:
                PerfilView(
                    nombreUsuario: $nombreUsuario,
                    genero: genero,
                    onCerrarSesion: onCerrarSesion,
                    onSeleccionarTab: { tabActual = $0 }
                )
            default: vistaInicio
            }
        }
        .overlay(alignment: .bottom) {
            if tabActual != 2 {
                premiumTabBar
                    .padding(.horizontal, 16)
                    .padding(.bottom, -19)
            }
        }
        .background(fondo.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .onAppear { cargarProgresoDesdeUserDefaults() }
    }

    // MARK: ─── PESTAÑA 0: HOME / INICIO ─────────────────────────────

    private var vistaInicio: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 26) {
                headerHero
                selectorEstado
                balanceProgresoCard
                actividadesGrid
                seccionHerramientasMuestra
            }
            .padding(.top, 10)
            .padding(.bottom, 110)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                animarInicio = true
            }
        }
    }

    // MARK: ─── COMPONENTES DE INICIO ─────────────────────────────

    private var headerHero: some View {
        VStack(spacing: 18) {
            HStack {
                HStack(spacing: 12) {
                    Image(genero == "hombre" ? "perfil boy" : "perfil")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 52, height: 52)
                        .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 2) {
                        Text(saludoHora)
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundColor(.gray)
                        Text(nombreUsuario)
                            .font(.system(size: 23, weight: .black, design: .rounded))
                    }
                }
                Spacer()
                HStack(spacing: 10) {
                    accionBoton(icono: "calendar")
                    accionBoton(icono: "bell")
                }
            }
            .padding(.horizontal, 20)

            // Tarjeta Liquid-Glass Estilo Semanal
            ZStack {
                RoundedRectangle(cornerRadius: 34)
                    .fill(LinearGradient(
                        colors: [morado1, morado2],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(height: 230)
                    .shadow(color: morado1.opacity(0.35), radius: 22, y: 12)

                Circle()
                    .fill(Color.white.opacity(0.08))
                    .frame(width: 180)
                    .offset(x: 120, y: -50)

                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 6) {
                                Image(systemName: "sparkles").foregroundColor(.yellow)
                                Text("TU PROGRESO SEMANAL")
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            Text("\(diasCompletados) de 7 días")
                                .font(.system(size: 34, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                            Text(diasCompletados == 0 ? "Empieza hoy tu registro 💪" : "Cada paso cuenta, vas increíble")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.85))
                        }
                        Spacer()
                    }

                    Spacer()

                    HStack(spacing: 10) {
                        ForEach(Array(diasSemana.enumerated()), id: \.offset) { index, dia in
                            let activo = diasActivos[index]
                            VStack(spacing: 6) {
                                Text(dia)
                                    .font(.system(size: 11, weight: .bold, design: .rounded))
                                    .foregroundColor(.white.opacity(0.7))
                                ZStack {
                                    Circle()
                                        .fill(activo ? Color.white : Color.white.opacity(0.18))
                                        .frame(width: 32, height: 32)
                                    if activo {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 11, weight: .bold))
                                            .foregroundColor(morado2)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding(22)
            }
            .padding(.horizontal, 16)
        }
    }

    private var selectorEstado: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("¿Cómo te sientes hoy?")
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .padding(.horizontal, 20)

            HStack(spacing: 12) {
                let esHombre = genero == "hombre"
                estadoCard(titulo: "Feliz",    imagen: esHombre ? "memoji boy feliz"   : "memoji alegria")
                estadoCard(titulo: "Triste",   imagen: esHombre ? "memoji boy triste"  : "memoji triste")
                estadoCard(titulo: "Enojado",  imagen: esHombre ? "memoji boy enojado" : "memoji enojada")
                estadoCard(titulo: "Angustia", imagen: esHombre ? "memoji boy timidez" : "memoji angustia")
            }
            .padding(.horizontal, 20)
        }
    }

    private func estadoCard(titulo: String, imagen: String) -> some View {
        let seleccionado = estadoSeleccionado == titulo
        return Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                estadoSeleccionado = titulo
            }
        } label: {
            VStack(spacing: 10) {
                Image(imagen)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 54, height: 54)
                    .clipShape(Circle())
                    .scaleEffect(seleccionado ? 1.15 : 1)
                    .shadow(color: seleccionado ? morado1.opacity(0.35) : .clear, radius: 10)
                Text(titulo)
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(seleccionado ? morado1.opacity(0.12) : Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(seleccionado ? morado1.opacity(0.4) : Color.clear, lineWidth: 2)
            )
            .scaleEffect(seleccionado ? 1.03 : 1)
        }
        .buttonStyle(.plain)
    }

    private var balanceProgresoCard: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .stroke(morado1.opacity(0.1), lineWidth: 6)
                    .frame(width: 56, height: 56)
                Circle()
                    .trim(from: 0, to: CGFloat(diasCompletados) / 7.0)
                    .stroke(
                        LinearGradient(colors: [morado1, .cyan], startPoint: .top, endPoint: .bottom),
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                    .frame(width: 56, height: 56)
                    .rotationEffect(.degrees(-90))
                
                Text("\(Int((Double(diasCompletados)/7.0)*100))%")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(morado2)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text("Balance general")
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                Text("Has completado un gran porcentaje de tus actividades semanales.")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            Spacer()
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .padding(.horizontal, 16)
    }

    private var actividadesGrid: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Actividades sugeridas")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                Spacer()
                Button { tabActual = 1 } label: {
                    HStack(spacing: 4) {
                        Text("Ver todo")
                        Image(systemName: "arrow.right")
                    }
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(morado1)
                }
            }
            .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(actividades, id: \.0) { actividad in
                        Button { tabActual = 1 } label: {
                            ZStack(alignment: .bottomLeading) {
                                Image(actividad.2)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 170, height: 170)
                                    .clipped()
                                LinearGradient(
                                    colors: [.black.opacity(0.65), .clear],
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(actividad.0)
                                        .font(.system(size: 17, weight: .black, design: .rounded))
                                        .foregroundColor(.white)
                                    Text(actividad.1)
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                .padding(16)
                            }
                            .frame(width: 170, height: 170)
                            .clipShape(RoundedRectangle(cornerRadius: 28))
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }

    private var seccionHerramientasMuestra: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Explora tus espacios")
                    .font(.system(size: 18, weight: .black, design: .rounded))
                Text("Transiciones directas a los pilares de tu bienestar.")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 20)

            VStack(spacing: 14) {
                HStack(spacing: 14) {
                    MuestraModuloCard(
                        titulo: "Asistente AI",
                        subtitulo: "Chat de contención",
                        icono: "bubble.left.and.bubble.right.fill",
                        color1: morado1,
                        color2: morado2
                    ) {
                        tabActual = 2
                    }
                    
                    MuestraModuloCard(
                        titulo: "Tus Hábitos",
                        subtitulo: "Gestión diaria",
                        icono: "checkmark.seal.fill",
                        color1: .teal,
                        color2: .emerald
                    ) {
                        tabActual = 1
                    }
                }
                HStack(spacing: 14) {
                    MuestraModuloCard(
                        titulo: "Inspiración",
                        subtitulo: "Frases de calma",
                        icono: "quote.bubble.fill",
                        color1: .orange,
                        color2: .rose
                    ) {
                        tabActual = 3
                    }
                    
                    MuestraModuloCard(
                        titulo: "Tu Perfil",
                        subtitulo: "Configuración",
                        icono: "person.fill",
                        color1: .blue,
                        color2: .indigo
                    ) {
                        tabActual = 4
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    // MARK: ─── NAV BAR PREMIUM TAB BAR ─────────────────────────────

    private var premiumTabBar: some View {
        ZStack(alignment: .top) {
            HStack(spacing: 0) {
                tabButton(icono: "house.fill",         titulo: "Inicio",  index: 0)
                tabButton(icono: "checkmark.seal.fill", titulo: "Hábitos", index: 1)
                Spacer().frame(width: 82)
                tabButton(icono: "quote.bubble.fill",   titulo: "Frases",  index: 3)
                tabButton(icono: "person.fill",         titulo: "Perfil",  index: 4)
            }
            .padding(.horizontal, 10)
            .padding(.top, 16)
            .padding(.bottom, 14)
            .background(
                RoundedRectangle(cornerRadius: 34)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.10), radius: 20, x: 0, y: 8)
            )

            Button { tabActual = 2 } label: {
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            colors: [morado1, morado2],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 66, height: 66)
                        .shadow(color: morado1.opacity(0.45), radius: 14, y: 6)

                    Image(systemName: "bubble.left.and.bubble.right.fill")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .offset(y: -18)
        }
    }

    // MARK: ─── ELEMENTOS INTERNOS DE CONTROL ─────────────────────────────

    private func tabButton(icono: String, titulo: String, index: Int) -> some View {
        let activo = tabActual == index
        return Button { tabActual = index } label: {
            VStack(spacing: 5) {
                Image(systemName: icono)
                    .font(.system(size: 18, weight: activo ? .bold : .medium))
                    .foregroundColor(activo ? morado1 : .gray)
                Text(titulo)
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(activo ? morado1 : .gray)
            }
            .frame(maxWidth: .infinity)
        }
    }

    private func accionBoton(icono: String) -> some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 42, height: 42)
            Image(systemName: icono)
                .foregroundColor(.black.opacity(0.7))
        }
    }

    private func cargarProgresoDesdeUserDefaults() {
        let defaults = UserDefaults.standard
        let calendar = Calendar.current
        let hoy = calendar.startOfDay(for: Date())
        var guardados = Set(
            defaults.array(forKey: "appAnsiedad_diasActivos") as? [Double] ?? []
        )
        guardados.insert(hoy.timeIntervalSince1970)
        defaults.set(Array(guardados), forKey: "appAnsiedad_diasActivos")
        diasActivos = (0..<7).map { offset in
            guard let dia = calendar.date(
                byAdding: .day,
                value: offset - indiceHoyEnSemana(),
                to: hoy
            ) else { return false }
            return guardados.contains(calendar.startOfDay(for: dia).timeIntervalSince1970)
        }
    }

    private func indiceHoyEnSemana() -> Int {
        let weekday = Calendar.current.component(.weekday, from: Date())
        return (weekday + 5) % 7
    }
}

// MARK: ─── TARJETA MUESTRA MODULO ───────────────────────────────────

struct MuestraModuloCard: View {
    let titulo: String
    let subtitulo: String
    let icono: String
    let color1: Color
    let color2: Color
    var alPresionar: () -> Void

    var body: some View {
        Button(action: {
            alPresionar()
        }) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(colors: [color1, color2], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 46, height: 46)
                        
                        Image(systemName: icono)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .shadow(color: color1.opacity(0.3), radius: 8, x: 0, y: 4)
                    
                    Spacer()
                    
                    Image(systemName: "arrow.up.forward.circle.fill")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(color1.opacity(0.35))
                }
                
                Spacer(minLength: 0)
                
                Text(titulo)
                    .font(.system(size: 16, weight: .black, design: .rounded))
                    .foregroundColor(.black.opacity(0.85))
                
                Text(subtitulo)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .padding(.top, 3)
            }
            .padding(16)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .overlay(
            RoundedRectangle(cornerRadius: 28)
                .stroke(LinearGradient(colors: [color1.opacity(0.15), Color.clear], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1.5)
        )
        .shadow(color: color1.opacity(0.04), radius: 14, x: 0, y: 8)
        .buttonStyle(CardFeedBackStyle())
    }
}

struct CardFeedBackStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

extension Color {
    static let emerald = Color(red: 16/255, green: 185/255, blue: 129/255)
    static let rose = Color(red: 244/255, green: 63/255, blue: 94/255)
}

// MARK: ─── PREVIEW ─────────────────────────────

#Preview {
    MenuView(
        nombreUsuario: "Daniel",
        genero: "hombre",
        onCerrarSesion: {}
    )
}
