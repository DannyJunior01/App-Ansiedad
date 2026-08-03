import SwiftUI

struct HabitoDetalleView: View {

    let habito: HabitoContenido
    let nombreUsuario: String

    @Environment(\.dismiss) private var dismiss

    @State private var aparecio = false
    @State private var consejosCompletados: Set<Int> = []

    private let purpura = Color(
        red: 101/255,
        green: 89/255,
        blue: 255/255
    )

    private let fondo = Color(
        red: 245/255,
        green: 245/255,
        blue: 248/255
    )

    // MARK: - Progreso

    private var progreso: Double {

        if habito.consejos.isEmpty {
            return 0
        }

        return Double(consejosCompletados.count)
        / Double(habito.consejos.count)
    }

    // MARK: - Altura uniforme

    private var alturaHero: CGFloat {
        300
    }

    // MARK: - Posición imagen

    private var offsetImagen: CGFloat {

        switch habito.id {

        case "ejercicio":
            return 0

        case "journaling":
            return 0

        case "lectura":
            return -10

        case "alimentacion":
            return -15

        default:
            return 0
        }
    }

    // MARK: - Zoom imagen

    private var escalaImagen: CGFloat {

        switch habito.id {

        case "ejercicio":
            return 1.15

        case "journaling":
            return 1.10

        case "lectura":
            return 1.08

        case "alimentacion":
            return 1.12

        default:
            return 1.10
        }
    }

    var body: some View {

        ZStack {

            fondo
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {

                VStack(spacing: 0) {

                    // MARK: HERO

                    ZStack(alignment: .bottomLeading) {

                        Image(habito.imagen)
                            .resizable()
                            .scaledToFill()
                            .scaleEffect(escalaImagen)
                            .frame(
                                width: UIScreen.main.bounds.width,
                                height: alturaHero
                            )
                            .offset(y: offsetImagen)
                            .clipped()

                        LinearGradient(
                            colors: [
                                .clear,
                                .black.opacity(0.78)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )

                        VStack(
                            alignment: .leading,
                            spacing: 10
                        ) {

                            HStack(spacing: 10) {

                                ZStack {

                                    Circle()
                                        .fill(habito.color)
                                        .frame(
                                            width: 42,
                                            height: 42
                                        )

                                    Image(systemName: habito.icono)
                                        .font(
                                            .system(
                                                size: 18,
                                                weight: .bold
                                            )
                                        )
                                        .foregroundColor(.white)
                                }

                                Text(habito.titulo)
                                    .font(
                                        .system(
                                            size: 28,
                                            weight: .bold,
                                            design: .rounded
                                        )
                                    )
                                    .foregroundColor(.white)
                            }

                            Text(habito.subtitulo)
                                .font(
                                    .system(
                                        size: 15,
                                        weight: .medium,
                                        design: .rounded
                                    )
                                )
                                .foregroundColor(
                                    .white.opacity(0.92)
                                )
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 28)
                        .opacity(aparecio ? 1 : 0)
                        .offset(y: aparecio ? 0 : 18)
                    }
                    .frame(height: alturaHero)

                    VStack(spacing: 24) {

                        // MARK: ANIMACIÓN

                        animacionEspecial
                            .padding(.top, 22)

                        // MARK: INTRO

                        Text(habito.intro)
                            .font(
                                .system(
                                    size: 18,
                                    weight: .medium,
                                    design: .rounded
                                )
                            )
                            .foregroundColor(
                                .black.opacity(0.82)
                            )
                            .multilineTextAlignment(.center)
                            .lineSpacing(6)
                            .padding(.horizontal, 28)

                        // MARK: PROGRESO

                        VStack(spacing: 18) {

                            HStack {

                                VStack(
                                    alignment: .leading,
                                    spacing: 5
                                ) {

                                    Text("Tu progreso")
                                        .font(
                                            .system(
                                                size: 17,
                                                weight: .bold,
                                                design: .rounded
                                            )
                                        )

                                    Text(
                                        "\(consejosCompletados.count) de \(habito.consejos.count) consejos completados"
                                    )
                                    .font(
                                        .system(
                                            size: 12,
                                            weight: .medium,
                                            design: .rounded
                                        )
                                    )
                                    .foregroundColor(.gray)
                                }

                                Spacer()

                                Image("perfil")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(
                                        width: 54,
                                        height: 54
                                    )
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(
                                                .white,
                                                lineWidth: 3
                                            )
                                    )
                                    .shadow(
                                        color: .black.opacity(0.12),
                                        radius: 8,
                                        y: 4
                                    )
                            }

                            VStack(spacing: 8) {

                                HStack {

                                    Text("Avance")
                                        .font(
                                            .system(
                                                size: 14,
                                                weight: .bold,
                                                design: .rounded
                                            )
                                        )

                                    Spacer()

                                    Text(
                                        "\(Int(progreso * 100))%"
                                    )
                                    .font(
                                        .system(
                                            size: 15,
                                            weight: .bold,
                                            design: .rounded
                                        )
                                    )
                                    .foregroundColor(habito.color)
                                }

                                GeometryReader { geo in

                                    ZStack(alignment: .leading) {

                                        Capsule()
                                            .fill(
                                                Color.white.opacity(0.75)
                                            )

                                        Capsule()
                                            .fill(
                                                LinearGradient(
                                                    colors: [
                                                        habito.color,
                                                        purpura
                                                    ],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .frame(
                                                width: geo.size.width * progreso
                                            )
                                            .animation(
                                                .spring(
                                                    response: 0.45,
                                                    dampingFraction: 0.82
                                                ),
                                                value: progreso
                                            )
                                    }
                                }
                                .frame(height: 14)
                            }
                        }
                        .padding(22)
                        .background(
                            RoundedRectangle(
                                cornerRadius: 26,
                                style: .continuous
                            )
                            .fill(
                                LinearGradient(
                                    colors: [
                                        habito.color.opacity(0.14),
                                        purpura.opacity(0.12)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        )
                        .padding(.horizontal, 20)

                        // MARK: CONSEJOS

                        VStack(
                            alignment: .leading,
                            spacing: 16
                        ) {

                            HStack {

                                Text("Consejos para hoy")
                                    .font(
                                        .system(
                                            size: 22,
                                            weight: .bold,
                                            design: .rounded
                                        )
                                    )

                                Spacer()

                                Text("\(habito.consejos.count)")
                                    .font(
                                        .system(
                                            size: 15,
                                            weight: .bold,
                                            design: .rounded
                                        )
                                    )
                                    .foregroundColor(habito.color)
                            }
                            .padding(.horizontal, 22)

                            ForEach(
                                Array(habito.consejos.enumerated()),
                                id: \.offset
                            ) { index, consejo in

                                let completado =
                                consejosCompletados.contains(index)

                                Button {

                                    withAnimation(
                                        .spring(
                                            response: 0.4,
                                            dampingFraction: 0.8
                                        )
                                    ) {

                                        if completado {

                                            consejosCompletados.remove(index)

                                        } else {

                                            consejosCompletados.insert(index)
                                        }
                                    }

                                } label: {

                                    HStack(
                                        alignment: .top,
                                        spacing: 16
                                    ) {

                                        ZStack {

                                            Circle()
                                                .fill(
                                                    completado
                                                    ? habito.color
                                                    : habito.color.opacity(0.14)
                                                )
                                                .frame(
                                                    width: 34,
                                                    height: 34
                                                )

                                            if completado {

                                                Image(
                                                    systemName: "checkmark"
                                                )
                                                .font(
                                                    .system(
                                                        size: 14,
                                                        weight: .bold
                                                    )
                                                )
                                                .foregroundColor(.white)

                                            } else {

                                                Text("\(index + 1)")
                                                    .font(
                                                        .system(
                                                            size: 14,
                                                            weight: .bold,
                                                            design: .rounded
                                                        )
                                                    )
                                                    .foregroundColor(habito.color)
                                            }
                                        }

                                        VStack(
                                            alignment: .leading,
                                            spacing: 6
                                        ) {

                                            Text(consejo)
                                                .font(
                                                    .system(
                                                        size: 15,
                                                        weight: .medium,
                                                        design: .rounded
                                                    )
                                                )
                                                .foregroundColor(
                                                    .black.opacity(0.84)
                                                )
                                                .multilineTextAlignment(.leading)

                                            Text(
                                                completado
                                                ? "Consejo completado"
                                                : "Toca para guardar progreso"
                                            )
                                            .font(
                                                .system(
                                                    size: 12,
                                                    weight: .medium,
                                                    design: .rounded
                                                )
                                            )
                                            .foregroundColor(
                                                completado
                                                ? habito.color
                                                : .gray
                                            )
                                        }

                                        Spacer()
                                    }
                                    .padding(18)
                                    .background(
                                        RoundedRectangle(
                                            cornerRadius: 22,
                                            style: .continuous
                                        )
                                        .fill(Color.white)
                                        .shadow(
                                            color: .black.opacity(0.05),
                                            radius: 10,
                                            y: 5
                                        )
                                    )
                                    .scaleEffect(
                                        completado ? 1.02 : 1
                                    )
                                }
                                .buttonStyle(.plain)
                                .padding(.horizontal, 20)
                            }
                        }

                        // MARK: BOTÓN

                        Button {

                            dismiss()

                        } label: {

                            HStack(spacing: 10) {

                                Image(
                                    systemName: "bookmark.fill"
                                )

                                Text("Guardar progreso")
                                    .font(
                                        .system(
                                            size: 17,
                                            weight: .bold,
                                            design: .rounded
                                        )
                                    )
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                LinearGradient(
                                    colors: [
                                        habito.color,
                                        purpura
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 20,
                                    style: .continuous
                                )
                            )
                            .shadow(
                                color: habito.color.opacity(0.28),
                                radius: 12,
                                y: 8
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 45)
                    }
                    .offset(y: -8)
                }
            }
        }
        .navigationBarBackButtonHidden(true)

        .toolbar {

            ToolbarItem(placement: .topBarLeading) {

                Button {

                    dismiss()

                } label: {

                    HStack(spacing: 5) {

                        Image(systemName: "chevron.left")

                        Text("Hábitos")
                    }
                    .font(
                        .system(
                            size: 15,
                            weight: .semibold,
                            design: .rounded
                        )
                    )
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 9)
                    .background(
                        Capsule()
                            .fill(
                                Color.black.opacity(0.34)
                            )
                    )
                }
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)

        .onAppear {

            withAnimation(
                .spring(
                    response: 0.55,
                    dampingFraction: 0.82
                )
            ) {

                aparecio = true
            }
        }
    }

    // MARK: ANIMACIONES

    @ViewBuilder
    private var animacionEspecial: some View {

        switch habito.tipoAnimacion {

        case .respiracion:

            HStack(spacing: 10) {

                ForEach(0..<5, id: \.self) { index in

                    RoundedRectangle(
                        cornerRadius: 20
                    )
                    .fill(habito.color)
                    .frame(
                        width: 8,
                        height: 34
                    )
                    .scaleEffect(
                        y: aparecio ? 1 : 0.4
                    )
                    .animation(
                        .easeInOut(duration: 0.7)
                        .repeatForever()
                        .delay(Double(index) * 0.08),
                        value: aparecio
                    )
                }
            }
            .frame(height: 40)

        case .meditacion:

            Image(systemName: "sparkles")
                .font(.system(size: 42))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            purpura,
                            habito.color
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .scaleEffect(aparecio ? 1 : 0.7)
                .animation(
                    .easeInOut(duration: 1.2)
                    .repeatForever(autoreverses: true),
                    value: aparecio
                )

        case .ejercicio:

            HStack(spacing: 8) {

                ForEach(0..<5, id: \.self) { index in

                    RoundedRectangle(
                        cornerRadius: 10
                    )
                    .fill(habito.color)
                    .frame(
                        width: 8,
                        height: 38
                    )
                    .scaleEffect(
                        y: aparecio ? 1 : 0.45
                    )
                    .animation(
                        .easeInOut(duration: 0.5)
                        .repeatForever()
                        .delay(Double(index) * 0.1),
                        value: aparecio
                    )
                }
            }

        case .general:

            HStack(spacing: 6) {

                ForEach(0..<3, id: \.self) { _ in

                    Image(systemName: "heart.fill")
                        .font(.system(size: 18))
                        .foregroundColor(habito.color)
                        .scaleEffect(aparecio ? 1.1 : 0.8)
                        .animation(
                            .easeInOut(duration: 0.8)
                            .repeatForever(autoreverses: true),
                            value: aparecio
                        )
                }
            }
        }
    }
}

#Preview {

    NavigationStack {

        HabitoDetalleView(
            habito: HabitoCatalog.todos[0],
            nombreUsuario: "Carla"
        )
    }
}
