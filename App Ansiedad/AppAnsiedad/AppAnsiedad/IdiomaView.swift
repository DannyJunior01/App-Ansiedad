import SwiftUI

struct IdiomaView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var idiomaSeleccionado = UsuarioService.idioma

    private let purpura = Color(red: 101/255, green: 89/255, blue: 255/255)

    private let idiomas: [(codigo: String, nombre: String, bandera: String)] = [
        ("es", "Español", "🇲🇽"),
        ("en", "English", "🇺🇸")
    ]

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(idiomas, id: \.codigo) { idioma in
                        Button {
                            idiomaSeleccionado = idioma.codigo
                        } label: {
                            HStack {
                                Text(idioma.bandera)
                                    .font(.system(size: 24))
                                Text(idioma.nombre)
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundColor(.primary)
                                Spacer()
                                if idiomaSeleccionado == idioma.codigo {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(purpura)
                                }
                            }
                        }
                    }
                } footer: {
                    Text("El idioma se guardará para cuando la app tenga traducción completa.")
                        .font(.system(size: 12, design: .rounded))
                }
            }
            .navigationTitle("Idioma")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        UsuarioService.idioma = idiomaSeleccionado
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(purpura)
                }
            }
        }
    }
}
