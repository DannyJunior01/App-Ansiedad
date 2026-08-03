import SwiftUI

struct EditarPerfilView: View {

    @Binding var nombreUsuario: String
    let correo: String
    let genero: String

    @Environment(\.dismiss) private var dismiss

    @State private var nombreEditado = ""
    @State private var cargando = false
    @State private var errorMensaje: String?
    @State private var exito = false

    private let purpura = Color(red: 101/255, green: 89/255, blue: 255/255)
    private let violeta = Color(red: 169/255, green: 102/255, blue: 255/255)

    private var imagenPerfil: String { genero == "hombre" ? "perfil boy" : "perfil" }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Image(imagenPerfil)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 88, height: 88)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(purpura.opacity(0.3), lineWidth: 3))
                        .padding(.top, 8)

                    Text("Tu avatar está definido según tu perfil")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Nombre")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.gray)
                        TextField("Tu nombre", text: $nombreEditado)
                            .font(.system(size: 16, design: .rounded))
                            .padding(16)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Correo")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.gray)
                        Text(correo)
                            .font(.system(size: 16, design: .rounded))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(16)
                            .background(Color(red: 245/255, green: 245/255, blue: 248/255))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }

                    if let errorMensaje {
                        Text(errorMensaje)
                            .font(.system(size: 13))
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    Button(action: guardar) {
                        ZStack {
                            Text("Guardar cambios")
                                .font(.system(size: 17, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .opacity(cargando ? 0 : 1)
                            if cargando { ProgressView().tint(.white) }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(LinearGradient(colors: [purpura, violeta], startPoint: .leading, endPoint: .trailing))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .disabled(nombreEditado.trimmingCharacters(in: .whitespaces).isEmpty || cargando)
                }
                .padding(24)
            }
            .background(Color(red: 245/255, green: 245/255, blue: 248/255))
            .navigationTitle("Editar perfil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                        .foregroundColor(purpura)
                }
            }
            .onAppear { nombreEditado = nombreUsuario }
            .alert("¡Listo!", isPresented: $exito) {
                Button("OK") { dismiss() }
            } message: {
                Text("Tu nombre se actualizó correctamente.")
            }
        }
    }

    private func guardar() {
        let nombre = nombreEditado.trimmingCharacters(in: .whitespaces)
        guard !nombre.isEmpty else { return }
        cargando = true
        errorMensaje = nil
        UsuarioService.actualizarNombre(nombre) { error in
            cargando = false
            if let error {
                errorMensaje = error.localizedDescription
                return
            }
            nombreUsuario = nombre
            exito = true
        }
    }
}
