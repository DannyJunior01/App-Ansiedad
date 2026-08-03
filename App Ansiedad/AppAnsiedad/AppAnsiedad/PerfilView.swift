import SwiftUI

struct PerfilView: View {

    @Binding var nombreUsuario: String
    let genero: String
    var onCerrarSesion: () -> Void
    var onSeleccionarTab: (Int) -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var aparecio = false
    @State private var cargando = true
    @State private var correo = ""

    @State private var diasActivos = 1
    @State private var habitosHoy = 0
    @State private var frasesGuardadas: [FraseGuardada] = []
    @State private var progresoSemana: Double = 0

    @State private var mostrarEditar = false
    @State private var mostrarIdioma = false
    @State private var mostrarFrases = false
    @State private var mostrarAyuda = false
    @State private var mostrarAcerca = false
    @State private var mostrarAlertaCerrarSesion = false
    @State private var cerrandoSesion = false

    // NUEVAS ANIMACIONES
    @State private var pulsando = false
    @State private var flotando = false
    @State private var brillo = false

    private let purpura = Color(red: 101/255, green: 89/255,  blue: 255/255)
    private let violeta = Color(red: 169/255, green: 102/255, blue: 255/255)
    private let menta   = Color(red: 52/255,  green: 199/255, blue: 141/255)
    private let fondo   = Color(red: 245/255, green: 245/255, blue: 248/255)

    private var imagenPerfil: String {
        genero == "hombre" ? "perfil boy" : "perfil"
    }

    var body: some View {

        ScrollView(showsIndicators: false) {

            VStack(spacing: 0) {

                // MARK: HEADER
                ZStack(alignment: .bottom) {

                    // Fondo principal
                    LinearGradient(
                        colors: [purpura, violeta],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 260)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 34,
                            style: .continuous
                        )
                    )

                    // Glow animado
                    RoundedRectangle(
                        cornerRadius: 34,
                        style: .continuous
                    )
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.18),
                                Color.clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .blur(radius: brillo ? 14 : 6)
                    .opacity(brillo ? 1 : 0.6)
                    .animation(
                        .easeInOut(duration: 2.2)
                        .repeatForever(autoreverses: true),
                        value: brillo
                    )

                    // Decoraciones
                    Circle()
                        .fill(Color.white.opacity(0.08))
                        .frame(width: 180, height: 180)
                        .offset(x: 140, y: -70)
                        .scaleEffect(aparecio ? 1 : 0.4)
                        .animation(
                            .spring(response: 0.8, dampingFraction: 0.6),
                            value: aparecio
                        )

                    Circle()
                        .fill(Color.white.opacity(0.06))
                        .frame(width: 90, height: 90)
                        .offset(x: -120, y: -40)
                        .scaleEffect(aparecio ? 1 : 0.4)
                        .animation(
                            .spring(response: 0.8, dampingFraction: 0.7)
                            .delay(0.1),
                            value: aparecio
                        )

                    Circle()
                        .fill(Color.white.opacity(0.10))
                        .frame(width: 60, height: 60)
                        .offset(x: 100, y: 40)
                        .scaleEffect(aparecio ? 1 : 0.2)
                        .animation(
                            .spring(response: 0.9, dampingFraction: 0.5)
                            .delay(0.15),
                            value: aparecio
                        )

                    VStack(spacing: 16) {

                        // MARK: MEMOJI
                        ZStack {

                            // Ripple 1
                            Circle()
                                .stroke(
                                    Color.white.opacity(0.35),
                                    lineWidth: 2
                                )
                                .frame(width: 118, height: 118)
                                .scaleEffect(pulsando ? 1.24 : 1)
                                .opacity(pulsando ? 0 : 0.8)
                                .animation(
                                    .easeInOut(duration: 1.8)
                                    .repeatForever(autoreverses: false),
                                    value: pulsando
                                )

                            // Ripple 2
                            Circle()
                                .stroke(
                                    Color.white.opacity(0.18),
                                    lineWidth: 1.5
                                )
                                .frame(width: 118, height: 118)
                                .scaleEffect(pulsando ? 1.42 : 1)
                                .opacity(pulsando ? 0 : 0.6)
                                .animation(
                                    .easeInOut(duration: 1.8)
                                    .repeatForever(autoreverses: false)
                                    .delay(0.45),
                                    value: pulsando
                                )

                            // Glow
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.25),
                                            Color.clear
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 108, height: 108)
                                .blur(radius: 8)

                            // Imagen
                            Image(imagenPerfil)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 96, height: 96)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(
                                            LinearGradient(
                                                colors: [
                                                    Color.white,
                                                    Color.white.opacity(0.4)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 4
                                        )
                                )
                                .shadow(
                                    color: .black.opacity(0.18),
                                    radius: 18,
                                    y: 10
                                )
                        }
                        .offset(y: flotando ? -5 : 5)
                        .animation(
                            .easeInOut(duration: 2.5)
                            .repeatForever(autoreverses: true),
                            value: flotando
                        )
                        .scaleEffect(aparecio ? 1 : 0.3)
                        .opacity(aparecio ? 1 : 0)
                        .rotationEffect(.degrees(aparecio ? 0 : -18))
                        .animation(
                            .spring(response: 0.7, dampingFraction: 0.55)
                            .delay(0.15),
                            value: aparecio
                        )

                        // MARK: TEXTO
                        VStack(spacing: 8) {

                            Text(nombreUsuario)
                                .font(
                                    .system(
                                        size: 30,
                                        weight: .bold,
                                        design: .rounded
                                    )
                                )
                                .foregroundColor(.white)
                                .opacity(aparecio ? 1 : 0)
                                .offset(y: aparecio ? 0 : 14)
                                .animation(
                                    .spring(response: 0.7, dampingFraction: 0.7)
                                    .delay(0.2),
                                    value: aparecio
                                )

                            if !correo.isEmpty {

                                Text(correo)
                                    .font(
                                        .system(
                                            size: 13,
                                            weight: .medium,
                                            design: .rounded
                                        )
                                    )
                                    .foregroundColor(.white.opacity(0.85))
                                    .opacity(aparecio ? 1 : 0)
                                    .animation(
                                        .easeOut(duration: 0.5)
                                        .delay(0.28),
                                        value: aparecio
                                    )
                            }

                            HStack(spacing: 8) {

                                Image(systemName: "sparkles")
                                    .font(
                                        .system(
                                            size: 11,
                                            weight: .bold
                                        )
                                    )

                                Text("Cuidando tu bienestar")
                                    .font(
                                        .system(
                                            size: 13,
                                            weight: .semibold,
                                            design: .rounded
                                        )
                                    )
                            }
                            .foregroundColor(.white.opacity(0.92))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(0.18))
                                    .overlay(
                                        Capsule()
                                            .stroke(
                                                Color.white.opacity(0.15),
                                                lineWidth: 1
                                            )
                                    )
                            )
                            .opacity(aparecio ? 1 : 0)
                            .offset(y: aparecio ? 0 : 12)
                            .animation(
                                .spring(response: 0.6, dampingFraction: 0.75)
                                .delay(0.32),
                                value: aparecio
                            )
                        }
                    }
                    .padding(.bottom, 28)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 22)

                // MARK: STATS
                HStack(spacing: 12) {

                    statCard(
                        valor: "\(diasActivos)",
                        etiqueta: "Días activos",
                        icono: "flame.fill",
                        color: Color(
                            red: 255/255,
                            green: 149/255,
                            blue: 0/255
                        ),
                        accion: nil
                    )

                    statCard(
                        valor: "\(habitosHoy)/8",
                        etiqueta: "Hábitos explorados",
                        icono: "checkmark.seal.fill",
                        color: menta
                    ) {
                        onSeleccionarTab(1)
                    }

                    statCard(
                        valor: "\(frasesGuardadas.count)",
                        etiqueta: "Frases",
                        icono: "quote.bubble.fill",
                        color: violeta
                    ) {
                        mostrarFrases = true
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
                .opacity(aparecio ? 1 : 0)
                .offset(y: aparecio ? 0 : 16)
                .animation(
                    .spring(response: 0.7, dampingFraction: 0.8)
                    .delay(0.4),
                    value: aparecio
                )

                // MARK: PROGRESO
                ZStack {

                    RoundedRectangle(
                        cornerRadius: 26,
                        style: .continuous
                    )
                    .fill(
                        LinearGradient(
                            colors: [
                                purpura.opacity(0.13),
                                violeta.opacity(0.08)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                    RoundedRectangle(
                        cornerRadius: 26,
                        style: .continuous
                    )
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.7),
                                Color.white.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )

                    HStack(spacing: 16) {

                        ZStack {

                            Circle()
                                .stroke(
                                    purpura.opacity(0.15),
                                    lineWidth: 7
                                )
                                .frame(width: 62, height: 62)

                            Circle()
                                .trim(from: 0, to: progresoSemana)
                                .stroke(
                                    LinearGradient(
                                        colors: [purpura, violeta],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    style: StrokeStyle(
                                        lineWidth: 7,
                                        lineCap: .round
                                    )
                                )
                                .frame(width: 62, height: 62)
                                .rotationEffect(.degrees(-90))

                            Text("\(Int(progresoSemana * 100))%")
                                .font(
                                    .system(
                                        size: 14,
                                        weight: .bold,
                                        design: .rounded
                                    )
                                )
                                .foregroundColor(purpura)
                        }

                        VStack(alignment: .leading, spacing: 5) {

                            Text("Tu semana de calma")
                                .font(
                                    .system(
                                        size: 17,
                                        weight: .bold,
                                        design: .rounded
                                    )
                                )
                                .foregroundColor(.black.opacity(0.88))

                            Text(mensajeProgreso)
                                .font(
                                    .system(
                                        size: 13,
                                        weight: .medium,
                                        design: .rounded
                                    )
                                )
                                .foregroundColor(.gray)
                        }

                        Spacer()
                    }
                    .padding(20)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 26)

                // MARK: SECCIONES
                seccion(titulo: "Mi cuenta") {

                    filaOpcion(
                        icono: "person.crop.circle",
                        titulo: "Editar perfil",
                        color: purpura
                    ) {
                        mostrarEditar = true
                    }
                }

                seccion(titulo: "Preferencias") {

                    filaOpcion(
                        icono: "globe",
                        titulo: "Idioma",
                        color: Color(
                            red: 120/255,
                            green: 145/255,
                            blue: 210/255
                        )
                    ) {
                        mostrarIdioma = true
                    }

                    filaOpcion(
                        icono: "heart.text.square.fill",
                        titulo: "Mis frases guardadas",
                        color: Color(
                            red: 255/255,
                            green: 120/255,
                            blue: 140/255
                        )
                    ) {
                        mostrarFrases = true
                    }
                }

                seccion(titulo: "Soporte") {

                    filaOpcion(
                        icono: "questionmark.circle.fill",
                        titulo: "Centro de ayuda",
                        color: purpura
                    ) {
                        mostrarAyuda = true
                    }

                    filaOpcion(
                        icono: "info.circle.fill",
                        titulo: "Acerca de la app",
                        color: Color(
                            red: 140/255,
                            green: 140/255,
                            blue: 160/255
                        )
                    ) {
                        mostrarAcerca = true
                    }
                }

                // MARK: BOTÓN
                Button {

                    mostrarAlertaCerrarSesion = true

                } label: {

                    HStack(spacing: 10) {

                        if cerrandoSesion {

                            ProgressView()
                                .tint(
                                    Color(
                                        red: 230/255,
                                        green: 70/255,
                                        blue: 80/255
                                    )
                                )

                        } else {

                            Image(
                                systemName: "rectangle.portrait.and.arrow.right"
                            )

                            Text("Cerrar sesión")
                                .font(
                                    .system(
                                        size: 16,
                                        weight: .bold,
                                        design: .rounded
                                    )
                                )
                        }
                    }
                    .foregroundColor(
                        Color(
                            red: 230/255,
                            green: 70/255,
                            blue: 80/255
                        )
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 22,
                            style: .continuous
                        )
                        .fill(
                            Color(
                                red: 255/255,
                                green: 240/255,
                                blue: 242/255
                            )
                        )
                    )
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 120)
            }
        }
        .background(fondo)
        .overlay {

            if cargando {

                ProgressView()
                    .scaleEffect(1.1)
                    .tint(purpura)
            }
        }
        .onAppear {

            cargarDatos()
            habitosHoy = UsuarioService.cantidadHabitosHoy

            withAnimation(
                .spring(
                    response: 0.7,
                    dampingFraction: 0.78
                )
            ) {
                aparecio = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

                pulsando = true
                flotando = true
                brillo = true
            }
        }

        // SHEETS
        .sheet(isPresented: $mostrarEditar) {

            EditarPerfilView(
                nombreUsuario: $nombreUsuario,
                correo: correo,
                genero: genero
            )
        }

        .sheet(isPresented: $mostrarIdioma) {
            IdiomaView()
        }

        .sheet(isPresented: $mostrarFrases) {
            FrasesGuardadasView(frases: frasesGuardadas)
        }

        .sheet(isPresented: $mostrarAyuda) {
            CentroAyudaView()
        }

        .sheet(isPresented: $mostrarAcerca) {
            AcercaView()
        }

        .alert(
            "¿Cerrar sesión?",
            isPresented: $mostrarAlertaCerrarSesion
        ) {

            Button("Cancelar", role: .cancel) {}

            Button("Cerrar sesión", role: .destructive) {
                ejecutarCerrarSesion()
            }

        } message: {

            Text("Volverás a la pantalla de inicio de sesión.")
        }
    }

    // MARK: MENSAJE PROGRESO
    private var mensajeProgreso: String {

        let pct = Int(progresoSemana * 100)

        if pct >= 80 {
            return "¡Increíble! Vas muy bien esta semana."
        }

        if pct >= 40 {
            return "Vas por buen camino, sigue así."
        }

        return "Cada día que entras cuenta. ¡Tú puedes!"
    }

    // MARK: CARGAR DATOS
    private func cargarDatos() {

        cargando = true

        UsuarioService.cargarPerfil { result in

            cargando = false

            switch result {

            case .success(let datos):

                nombreUsuario = datos.nombre
                correo = datos.correo
                diasActivos = datos.diasActivos
                habitosHoy = UsuarioService.cantidadHabitosHoy
                frasesGuardadas = datos.frasesGuardadas

                let base = min(
                    1.0,
                    Double(diasActivos) / 14.0 * 0.5 +
                    Double(frasesGuardadas.count) / 10.0 * 0.5
                )

                progresoSemana = max(0.08, base)

            case .failure:

                correo = UsuarioService.correoActual
            }
        }
    }

    // MARK: CERRAR SESIÓN
    private func ejecutarCerrarSesion() {

        cerrandoSesion = true

        do {

            try UsuarioService.cerrarSesion()

            cerrandoSesion = false

            onCerrarSesion()

            dismiss()

        } catch {

            cerrandoSesion = false
        }
    }

    // MARK: COMPONENTES
    @ViewBuilder
    private func statCard(
        valor: String,
        etiqueta: String,
        icono: String,
        color: Color,
        accion: (() -> Void)?
    ) -> some View {

        Button {

            accion?()

        } label: {

            VStack(spacing: 10) {

                ZStack {

                    Circle()
                        .fill(color.opacity(0.14))
                        .frame(width: 42, height: 42)

                    Image(systemName: icono)
                        .font(
                            .system(
                                size: 16,
                                weight: .bold
                            )
                        )
                        .foregroundColor(color)
                }

                Text(valor)
                    .font(
                        .system(
                            size: 22,
                            weight: .bold,
                            design: .rounded
                        )
                    )
                    .foregroundColor(.black.opacity(0.88))

                Text(etiqueta)
                    .font(
                        .system(
                            size: 11,
                            weight: .semibold,
                            design: .rounded
                        )
                    )
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(
                    cornerRadius: 24,
                    style: .continuous
                )
                .fill(Color.white)
                .shadow(
                    color: .black.opacity(0.05),
                    radius: 14,
                    y: 6
                )
            )
        }
        .buttonStyle(.plain)
        .disabled(accion == nil)
    }

    @ViewBuilder
    private func seccion(
        titulo: String,
        @ViewBuilder contenido: () -> some View
    ) -> some View {

        VStack(alignment: .leading, spacing: 12) {

            Text(titulo)
                .font(
                    .system(
                        size: 14,
                        weight: .bold,
                        design: .rounded
                    )
                )
                .foregroundColor(.gray)
                .padding(.horizontal, 24)

            VStack(spacing: 0) {
                contenido()
            }
            .background(
                RoundedRectangle(
                    cornerRadius: 24,
                    style: .continuous
                )
                .fill(Color.white)
                .shadow(
                    color: .black.opacity(0.05),
                    radius: 14,
                    y: 6
                )
            )
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 20)
    }

    @ViewBuilder
    private func filaOpcion(
        icono: String,
        titulo: String,
        color: Color,
        accion: @escaping () -> Void
    ) -> some View {

        Button(action: accion) {

            HStack(spacing: 14) {

                ZStack {

                    RoundedRectangle(
                        cornerRadius: 12,
                        style: .continuous
                    )
                    .fill(color.opacity(0.14))
                    .frame(width: 42, height: 42)

                    Image(systemName: icono)
                        .font(
                            .system(
                                size: 15,
                                weight: .bold
                            )
                        )
                        .foregroundColor(color)
                }

                Text(titulo)
                    .font(
                        .system(
                            size: 16,
                            weight: .semibold,
                            design: .rounded
                        )
                    )
                    .foregroundColor(.black.opacity(0.86))

                Spacer()

                Image(systemName: "chevron.right")
                    .font(
                        .system(
                            size: 13,
                            weight: .bold
                        )
                    )
                    .foregroundColor(.gray.opacity(0.4))
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 15)
        }
        .buttonStyle(.plain)
    }
}

#Preview {

    PerfilView(
        nombreUsuario: .constant("Carla"),
        genero: "mujer",
        onCerrarSesion: {},
        onSeleccionarTab: { _ in }
    )
}
