import SwiftUI

struct AcercaView: View {

    @Environment(\.dismiss) private var dismiss

    private let purpura = Color(red: 101/255, green: 89/255, blue: 255/255)
    private let violeta = Color(red: 169/255, green: 102/255, blue: 255/255)

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [purpura.opacity(0.15), violeta.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 100, height: 100)
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 44, weight: .semibold))
                        .foregroundStyle(LinearGradient(colors: [purpura, violeta], startPoint: .topLeading, endPoint: .bottomTrailing))
                }

                VStack(spacing: 8) {
                    Text("App Ansiedad")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                    Text("Versión 1.0.0")
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(.gray)
                }

                Text("Un espacio para cuidar tu bienestar emocional con actividades, frases y hábitos pensados para ti.")
                    .font(.system(size: 15, design: .rounded))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 32)

                Spacer()

                Text("Hecho con cariño para acompañarte 💜")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(purpura.opacity(0.8))
                    .padding(.bottom, 32)
            }
            .navigationTitle("Acerca de")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Listo") { dismiss() }
                        .foregroundColor(purpura)
                }
            }
        }
    }
}
