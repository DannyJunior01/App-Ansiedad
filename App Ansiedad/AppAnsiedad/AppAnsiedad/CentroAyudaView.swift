import SwiftUI

struct CentroAyudaView: View {

    @Environment(\.dismiss) private var dismiss

    private let purpura = Color(red: 101/255, green: 89/255, blue: 255/255)

    private let preguntas: [(pregunta: String, respuesta: String)] = [
        (
            "¿Cómo registro cómo me siento?",
            "En Inicio, toca uno de los memojis en «¿Cómo te sientes hoy?» y verás una frase hecha para ti."
        ),
        (
            "¿Cómo guardo una frase?",
            "Después de elegir tu emoción, toca el corazón en la tarjeta de la frase. La encontrarás en Perfil → Mis frases guardadas."
        ),
        (
            "¿Puedo cambiar mi nombre?",
            "Sí. Ve a Perfil → Editar perfil y actualiza tu nombre. Tu avatar se mantiene según tu perfil."
        ),
        (
            "¿Dónde veo mis frases guardadas?",
            "En Perfil → Mis frases guardadas encontrarás todas las que marcaste con el corazón en Inicio."
        )
    ]

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(preguntas.indices, id: \.self) { i in
                        DisclosureGroup {
                            Text(preguntas[i].respuesta)
                                .font(.system(size: 14, design: .rounded))
                                .foregroundColor(.gray)
                                .padding(.vertical, 4)
                        } label: {
                            Text(preguntas[i].pregunta)
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                        }
                    }
                }

                Section {
                    Link(destination: URL(string: "mailto:soporte@appansiedad.com?subject=Ayuda%20App%20Ansiedad")!) {
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(purpura)
                            Text("Escribir a soporte")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                        }
                    }
                }
            }
            .navigationTitle("Centro de ayuda")
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
