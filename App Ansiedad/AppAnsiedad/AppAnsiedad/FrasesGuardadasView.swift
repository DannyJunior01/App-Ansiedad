import SwiftUI

struct FrasesGuardadasView: View {

    let frases: [FraseGuardada]

    private let purpura = Color(red: 101/255, green: 89/255,  blue: 255/255)
    private let violeta = Color(red: 169/255, green: 102/255, blue: 255/255)

    // Mapa estado → colores de gradiente (igual que en MenuView)
    private func coloresPara(_ estado: String) -> [Color] {
        switch estado {
        case "alegria":
            return [Color(red: 255/255, green: 183/255, blue: 77/255),
                    Color(red: 255/255, green: 120/255, blue: 140/255)]
        case "triste":
            return [Color(red: 120/255, green: 145/255, blue: 210/255), purpura]
        case "enojado", "enojada":
            return [Color(red: 255/255, green: 120/255, blue: 100/255),
                    Color(red: 220/255, green: 70/255,  blue: 90/255)]
        case "timidez":
            return [Color(red: 186/255, green: 160/255, blue: 255/255),
                    Color(red: 130/255, green: 120/255, blue: 255/255)]
        case "angustia":
            return [Color(red: 90/255, green: 80/255, blue: 180/255),
                    Color(red: 60/255, green: 55/255, blue: 120/255)]
        default:
            return [purpura, violeta]
        }
    }

    var body: some View {
        ZStack {
            Color(red: 245/255, green: 245/255, blue: 248/255).ignoresSafeArea()

            VStack(spacing: 0) {

                // ── Header ──────────────────────────────
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Mis Frases")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.black.opacity(0.88))
                        Text("\(frases.count) guardada\(frases.count == 1 ? "" : "s")")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    ZStack {
                        Circle()
                            .fill(purpura.opacity(0.12))
                            .frame(width: 44, height: 44)
                        Image(systemName: "quote.bubble.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(
                                LinearGradient(colors: [purpura, violeta],
                                               startPoint: .topLeading,
                                               endPoint: .bottomTrailing)
                            )
                    }
                }
                .padding(.horizontal, 22)
                .padding(.top, 20)
                .padding(.bottom, 18)

                // ── Lista o estado vacío ────────────────
                if frases.isEmpty {
                    estadoVacio
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 14) {
                            ForEach(frases) { frase in
                                tarjetaFrase(frase)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 110)
                    }
                }
            }
        }
    }

    // MARK: - Tarjeta individual
    @ViewBuilder
    private func tarjetaFrase(_ item: FraseGuardada) -> some View {
        let colores = coloresPara(item.estado)

        ZStack(alignment: .bottomLeading) {

            // Fondo degradado
            RoundedRectangle(cornerRadius: 22)
                .fill(LinearGradient(colors: colores,
                                     startPoint: .topLeading,
                                     endPoint: .bottomTrailing))

            // Círculos decorativos
            Circle()
                .fill(Color.white.opacity(0.07))
                .frame(width: 100, height: 100)
                .offset(x: -60, y: -20)

            Circle()
                .fill(Color.white.opacity(0.05))
                .frame(width: 70, height: 70)
                .offset(x: 260, y: 30)

            // Contenido
            VStack(alignment: .leading, spacing: 10) {
                Text(item.etiqueta.uppercased())
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .tracking(2.2)
                    .foregroundColor(.white.opacity(0.8))

                Text(item.frase)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)

                HStack {
                    Label(item.estado.capitalized,
                          systemImage: "heart.fill")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                    Spacer()
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
        .shadow(color: colores.first?.opacity(0.3) ?? .clear, radius: 12, x: 0, y: 6)
    }

    // MARK: - Estado vacío
    private var estadoVacio: some View {
        VStack(spacing: 20) {
            Spacer()
            ZStack {
                Circle()
                    .fill(purpura.opacity(0.10))
                    .frame(width: 90, height: 90)
                Image(systemName: "heart.text.square.fill")
                    .font(.system(size: 38))
                    .foregroundStyle(
                        LinearGradient(colors: [purpura, violeta],
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing)
                    )
            }
            Text("Aún no tienes frases")
                .font(.system(size: 22, weight: .bold, design: .rounded))
            Text("Guarda las que te lleguen al corazón\ndesde la pantalla de inicio.")
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer()
        }
        .padding(.bottom, 100)
    }
}
