import SwiftUI
import FirebaseAuth
import FirebaseFirestore

// MARK: - MODOS DEL CHAT
enum ModoChat {
    case escuchar
    case panico
}

// MARK: - VIEW PRINCIPAL
struct ChatbotView: View {

    // MARK: - TAB + DATOS
    @Binding var tabActual: Int
    var nombreUsuario: String
    var genero: String

    // MARK: - ESTADOS
    @State private var mensajeEscrito = ""
    @State private var mensajes: [MensajeChat] = []
    @State private var mostrandoEscritura = false
    @State private var modoSeleccionado: ModoChat? = nil

    @FocusState private var inputActivo: Bool

    // MARK: - PALETA
    private let azul    = Color(red: 96/255,  green: 95/255,  blue: 255/255)
    private let morado  = Color(red: 125/255, green: 92/255,  blue: 255/255)

    private let fondo   = Color(red: 246/255, green: 247/255, blue: 252/255)

    // MARK: - EMOCIONES
    let emociones: [(emoji: String, label: String, color: Color)] = [
        ("", "Feliz",    Color(red: 255/255, green: 196/255, blue: 0/255)),
        ("", "Triste",   Color(red: 100/255, green: 130/255, blue: 230/255)),
        ("", "Ansioso",  Color(red: 140/255, green: 100/255, blue: 220/255)),
        ("", "Cansado",  Color(red: 90/255,  green: 160/255, blue: 220/255)),
        ("", "Enojado",  Color(red: 255/255, green: 90/255,  blue: 80/255))
    ]

    var body: some View {

        ZStack {
            fondo
                .ignoresSafeArea()

            VStack(spacing: 0) {

                headerChat

                if modoSeleccionado == nil {

                    selectorModo

                } else {

                    chatPrincipal
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - HEADER
extension ChatbotView {

    private var headerChat: some View {

        HStack(spacing: 12) {

            Button {

                inputActivo = false

                withAnimation(.spring(response: 0.38, dampingFraction: 0.86)) {
                    tabActual = 0
                }

            } label: {

                ZStack {

                    Circle()
                        .fill(Color.white)
                        .frame(width: 40, height: 40)
                        .shadow(color: .black.opacity(0.07), radius: 8, y: 3)

                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.black.opacity(0.70))
                }
            }
            .buttonStyle(.plain)

            // Avatar
            ZStack(alignment: .bottomTrailing) {

                Circle()
                    .fill(Color.white)
                    .frame(width: 46, height: 46)
                    .shadow(color: .black.opacity(0.08), radius: 8, y: 3)

                Image(genero == "hombre" ? "perfil boy" : "perfil")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 42, height: 42)
                    .clipShape(Circle())

                Circle()
                    .fill(Color.green)
                    .frame(width: 11, height: 11)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                    )
            }

            VStack(alignment: .leading, spacing: 1) {

                Text(nombreUsuario)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.black.opacity(0.88))

                HStack(spacing: 4) {

                    Circle()
                        .fill(Color.green)
                        .frame(width: 6, height: 6)

                    Text("Tu espacio seguro")
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundColor(.gray)
                }
            }

            Spacer()

            ZStack {

                Circle()
                    .fill(
                        LinearGradient(
                            colors: [azul, morado],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 42, height: 42)

                Image(systemName: "sparkles")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 18)
        .padding(.top, 56)
        .padding(.bottom, 14)
        .background(fondo)
    }
}

// MARK: - SELECTOR DE MODO
extension ChatbotView {

    private var selectorModo: some View {

        VStack(spacing: 26) {

            Spacer()

            Image("memojibanner")
                .resizable()
                .scaledToFit()
                .frame(width: 190)

            VStack(spacing: 10) {

                Text("¿Cómo quieres usar este espacio?")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)

                Text("Puedes hablar libremente o recibir ayuda durante un momento de ansiedad.")
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
            }

            VStack(spacing: 18) {

                // MODO ESCUCHAR
                Button {

                    modoSeleccionado = .escuchar
                    iniciarChatEscuchar()

                } label: {

                    HStack(spacing: 16) {

                        ZStack {

                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.purple.opacity(0.20),
                                            Color.blue.opacity(0.12)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 60, height: 60)

                            Text("💬")
                                .font(.system(size: 28))
                        }

                        VStack(alignment: .leading, spacing: 6) {

                            Text("Solo quiero hablar")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.black)

                            Text("Un espacio tranquilo para desahogarte y sentirte escuchado.")
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.leading)
                        }

                        Spacer()
                    }
                    .padding(20)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 28))
                    .shadow(color: .black.opacity(0.06), radius: 12, y: 5)
                }
                .buttonStyle(.plain)

                // MODO PANICO
                Button {

                    modoSeleccionado = .panico
                    iniciarChatPanico()

                } label: {

                    HStack(spacing: 16) {

                        ZStack {

                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            azul.opacity(0.18),
                                            morado.opacity(0.10)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 60, height: 60)

                            Text("🌿")
                                .font(.system(size: 28))
                        }

                        VStack(alignment: .leading, spacing: 6) {

                            Text("Ansiedad o ataque de pánico")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.black)

                            Text("Te ayudaré paso a paso a recuperar la calma.")
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundColor(.gray)
                        }

                        Spacer()
                    }
                    .padding(20)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 28))
                    .shadow(color: .black.opacity(0.06), radius: 12, y: 5)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 22)

            Spacer()
        }
    }
}

// MARK: - CHAT PRINCIPAL
extension ChatbotView {

    private var chatPrincipal: some View {

        VStack(spacing: 0) {

            ScrollViewReader { proxy in

                ScrollView(showsIndicators: false) {

                    VStack(spacing: 20) {

                        if modoSeleccionado == .escuchar {

                            emocionesRapidas
                        }

                        ForEach(mensajes) { mensaje in

                            mensajeBubble(mensaje)
                                .id(mensaje.id)
                        }

                        if mostrandoEscritura {

                            typingBubble
                                .id("typing")
                        }

                        Color.clear
                            .frame(height: 1)
                            .id("fondo")
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    .padding(.bottom, 80)
                }
                .onChange(of: mensajes.count) { _ in

                    withAnimation {
                        proxy.scrollTo("fondo", anchor: .bottom)
                    }
                }
                .onChange(of: mostrandoEscritura) { _ in

                    withAnimation {
                        proxy.scrollTo("fondo", anchor: .bottom)
                    }
                }
                .onTapGesture {

                    inputActivo = false
                }
            }

            inputChat
        }
    }
}

// MARK: - EMOCIONES
extension ChatbotView {

    private var emocionesRapidas: some View {

        VStack(alignment: .leading, spacing: 12) {

            Text("¿Cómo te sientes?")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(.gray)
                .padding(.leading, 2)

            ScrollView(.horizontal, showsIndicators: false) {

                HStack(spacing: 10) {

                    ForEach(emociones, id: \.label) { e in

                        Button {

                            seleccionarEmocion(e.label)

                        } label: {

                            HStack(spacing: 8) {

                                Text(e.emoji)
                                    .font(.system(size: 18))

                                Text(e.label)
                                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                                    .foregroundColor(e.color)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 11)
                            .background(e.color.opacity(0.10))
                            .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

// MARK: - MENSAJES
extension ChatbotView {

    private func mensajeBubble(_ mensaje: MensajeChat) -> some View {

        HStack(alignment: .bottom, spacing: 10) {

            if mensaje.esUsuario {

                Spacer(minLength: 52)

                Text(mensaje.texto)
                    .font(.system(size: 15, design: .rounded))
                    .foregroundColor(.white)
                    .lineSpacing(4)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            colors: [azul, morado],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))

            } else {

                ZStack {

                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    azul.opacity(0.15),
                                    morado.opacity(0.10)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 32, height: 32)

                    Image(systemName: "sparkles")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(azul)
                }

                Text(mensaje.texto)
                    .font(.system(size: 15, design: .rounded))
                    .foregroundColor(.black.opacity(0.82))
                    .lineSpacing(5)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 13)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.06), radius: 8, y: 3)

                Spacer(minLength: 52)
            }
        }
    }
}

// MARK: - TYPING
extension ChatbotView {

    private var typingBubble: some View {

        HStack(alignment: .bottom, spacing: 10) {

            ZStack {

                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                azul.opacity(0.15),
                                morado.opacity(0.10)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 32, height: 32)

                Image(systemName: "sparkles")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(azul)
            }

            HStack(spacing: 5) {

                ForEach(0..<3, id: \.self) { i in

                    Circle()
                        .fill(azul.opacity(0.45))
                        .frame(width: 7, height: 7)
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
            .background(Color.white)
            .clipShape(Capsule())

            Spacer()
        }
    }
}

// MARK: - INPUT
extension ChatbotView {

    private var inputChat: some View {

        VStack(spacing: 0) {

            Rectangle()
                .fill(Color.black.opacity(0.05))
                .frame(height: 1)

            HStack(alignment: .bottom, spacing: 12) {

                TextField(
                    modoSeleccionado == .panico
                    ? "Cuéntame qué estás sintiendo..."
                    : "Escribe aquí...",
                    text: $mensajeEscrito,
                    axis: .vertical
                )
                .font(.system(size: 15, design: .rounded))
                .lineLimit(1...5)
                .focused($inputActivo)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 22))

                Button {

                    enviarMensaje()

                } label: {

                    ZStack {

                        Circle()
                            .fill(
                                mensajeEscrito.trimmingCharacters(in: .whitespaces).isEmpty
                                ? LinearGradient(
                                    colors: [
                                        Color.gray.opacity(0.25),
                                        Color.gray.opacity(0.25)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                                : LinearGradient(
                                    colors: [azul, morado],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 48, height: 48)

                        Image(systemName: "arrow.up")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 10)
            .background(fondo)
        }
    }
}

// MARK: - FUNCIONES
extension ChatbotView {

    private func iniciarChatEscuchar() {

        mensajes = [

            MensajeChat(
                texto:
"""
Hola \(nombreUsuario) 💜

Este espacio es completamente tuyo.

Puedes hablar conmigo sin presión, sin juicios y sin tener que explicar todo perfecto.

¿Cómo te has sentido hoy?
""",
                esUsuario: false
            )
        ]
    }

    private func iniciarChatPanico() {

        mensajes = [

            MensajeChat(
                texto:
"""
Estoy contigo 🌿

Vamos poco a poco.

Primero:
pon ambos pies en el suelo.

Ahora respira lento conmigo.

Inhala 4 segundos...
Exhala despacio...

No estás solo.
""",
                esUsuario: false
            )
        ]
    }

    private func seleccionarEmocion(_ emocion: String) {

        withAnimation {

            mensajes.append(
                MensajeChat(
                    texto: "Me siento \(emocion.lowercased()) hoy.",
                    esUsuario: true
                )
            )
        }

        respuestaEmocion(emocion)
    }

    private func enviarMensaje() {

        let texto = mensajeEscrito.trimmingCharacters(in: .whitespaces)

        guard !texto.isEmpty else { return }

        withAnimation {

            mensajes.append(
                MensajeChat(
                    texto: texto,
                    esUsuario: true
                )
            )
        }

        mensajeEscrito = ""

        // DETECCIÓN AUTOMÁTICA DE PANICO
        let t = texto.lowercased()

        if t.contains("no puedo respirar") ||
            t.contains("me estoy muriendo") ||
            t.contains("ataque") ||
            t.contains("mucho miedo") ||
            t.contains("me siento raro") {

            modoSeleccionado = .panico
        }

        if modoSeleccionado == .panico {

            respuestaPanico(texto)

        } else {

            respuestaLibre(texto)
        }
    }
}

// MARK: - RESPUESTAS PANICO
extension ChatbotView {

    private func respuestaPanico(_ texto: String) {

        mostrandoEscritura = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {

            mostrandoEscritura = false

            let respuestas = [

"""
Mírame un momento 🌿

Tu respiración puede sentirse acelerada, pero va a pasar.

Inhala lento...
Ahora exhala más despacio.
""",

"""
No necesitas controlar todo ahora.

Solo enfócate en este momento.

Busca 5 cosas que puedas ver a tu alrededor.
""",

"""
Tu cuerpo está reaccionando al miedo, pero no significa que estés en peligro.

Sigue respirando conmigo 💜
""",

"""
Pon una mano en tu pecho.

Siente cómo el aire entra y sale lentamente.

Estás aquí.
Estás a salvo.
"""
            ]

            withAnimation {

                mensajes.append(
                    MensajeChat(
                        texto: respuestas.randomElement() ?? "",
                        esUsuario: false
                    )
                )
            }
        }
    }
}

// MARK: - RESPUESTAS NORMALES
extension ChatbotView {

    private func respuestaEmocion(_ emocion: String) {

        mostrandoEscritura = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {

            mostrandoEscritura = false

            var r = ""

            switch emocion {

            case "Feliz":

                r =
"""
Me alegra mucho leer eso 😊

¿Qué fue lo mejor de tu día?
"""

            case "Triste":

                r =
"""
Gracias por contármelo 💙

No tienes que cargar todo solo.

¿Quieres hablar de lo que pasó?
"""

            case "Ansioso":

                r =
"""
La ansiedad puede sentirse muy pesada 🌿

Pero aquí no tienes que esconder cómo te sientes.

¿Qué es lo que más te preocupa ahorita?
"""

            case "Cansado":

                r =
"""
A veces el cansancio no es solo físico 😴

La mente también se agota.

¿Cómo han estado estos días para ti?
"""

            default:

                r =
"""
Estoy aquí para escucharte 💜
"""
            }

            withAnimation {

                mensajes.append(
                    MensajeChat(
                        texto: r,
                        esUsuario: false
                    )
                )
            }
        }
    }

    private func respuestaLibre(_ texto: String) {

        mostrandoEscritura = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {

            mostrandoEscritura = false

            let t = texto.lowercased()

            var r = ""

            if t.contains("triste") || t.contains("llorar") {

                r =
"""
Llorar también es una forma de liberar lo que pesa 💙

No tienes que reprimirlo aquí.
"""

            } else if t.contains("solo") || t.contains("sola") {

                r =
"""
Sentirse solo duele mucho 💜

Pero ahora mismo estoy aquí contigo.
"""

            } else if t.contains("ansiedad") || t.contains("nervios") {

                r =
"""
La ansiedad puede hacer que todo se sienta demasiado grande 🌿

Vamos paso a paso.
"""

            } else {

                r =
"""
Gracias por compartir eso conmigo 💜

Te estoy escuchando de verdad.

Cuéntame más si quieres.
"""
            }

            withAnimation {

                mensajes.append(
                    MensajeChat(
                        texto: r,
                        esUsuario: false
                    )
                )
            }
        }
    }
}

// MARK: - MODELO
struct MensajeChat: Identifiable {

    let id = UUID()
    let texto: String
    let esUsuario: Bool
}

// MARK: - PREVIEW
#Preview {

    StatefulPreviewWrapper(2) { binding in

        ChatbotView(
            tabActual: binding,
            nombreUsuario: "Israel",
            genero: "hombre"
        )
    }
}

struct StatefulPreviewWrapper<Value, Content: View>: View {

    @State var value: Value

    let content: (Binding<Value>) -> Content

    init(
        _ value: Value,
        content: @escaping (Binding<Value>) -> Content
    ) {

        self._value = State(initialValue: value)
        self.content = content
    }

    var body: some View {

        content($value)
    }
}
