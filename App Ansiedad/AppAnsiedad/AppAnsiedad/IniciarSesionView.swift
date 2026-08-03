import SwiftUI
import FirebaseAuth
import FirebaseFirestore

// MARK: - Vista Recuperar Contraseña
struct RecuperarContrasenaView: View {

    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var cargando = false
    @State private var mensajeExito = false
    @State private var errorMensaje = ""
    @State private var mostrarError = false

    private let purpura = Color(red: 0.47, green: 0.38, blue: 0.93)
    private let azul    = Color(red: 0.20, green: 0.50, blue: 1.00)

    var body: some View {

        NavigationStack {

            ZStack {

                LinearGradient(
                    colors: [
                        Color(red: 0.97, green: 0.96, blue: 1.00),
                        Color(red: 0.93, green: 0.95, blue: 1.00)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {

                    Spacer().frame(height: 40)

                    // Ícono
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [purpura.opacity(0.15), azul.opacity(0.10)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 80, height: 80)

                        Image(systemName: "lock.rotation")
                            .font(.system(size: 34, weight: .semibold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [purpura, azul],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                    .padding(.bottom, 20)

                    // Título
                    VStack(spacing: 6) {
                        Text("Recuperar contraseña")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [purpura, azul],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )

                        Text("Te enviaremos un enlace para\nrestablecer tu contraseña")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.bottom, 36)

                    VStack(alignment: .leading, spacing: 16) {

                        // Campo email
                        VStack(alignment: .leading, spacing: 8) {

                            Label("Email", systemImage: "envelope.fill")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(red: 0.30, green: 0.30, blue: 0.40))

                            TextField("correo@email.com", text: $email)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .font(.system(size: 16))
                                .padding(.horizontal, 16)
                                .frame(height: 54)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
                                .disabled(mensajeExito)
                        }

                        // Mensaje éxito
                        if mensajeExito {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text("¡Correo enviado!")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(.green)
                                    Text("Revisa tu bandeja de entrada y sigue las instrucciones.")
                                        .font(.system(size: 12))
                                        .foregroundColor(.green.opacity(0.8))
                                }
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 12)
                            .background(Color.green.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .transition(.scale.combined(with: .opacity))
                        }

                        // Mensaje error
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
                            .transition(.scale.combined(with: .opacity))
                        }

                        // Botón enviar
                        Button(action: recuperarContrasena) {
                            ZStack {
                                Text(mensajeExito ? "Correo enviado ✓" : "Enviar enlace")
                                    .foregroundColor(.white)
                                    .font(.system(size: 17, weight: .bold))
                                    .opacity(cargando ? 0 : 1)

                                if cargando {
                                    ProgressView().tint(.white)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(
                            LinearGradient(
                                colors: mensajeExito
                                    ? [Color.green.opacity(0.7), Color.green.opacity(0.5)]
                                    : [purpura, azul],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: purpura.opacity(0.35), radius: 12, x: 0, y: 6)
                        .disabled(cargando || mensajeExito)
                        .padding(.top, 4)

                        // Volver
                        Button(action: { dismiss() }) {
                            HStack(spacing: 4) {
                                Image(systemName: "arrow.left")
                                Text("Volver al inicio de sesión")
                            }
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [purpura, azul],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .font(.system(size: 15, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 4)
                    }
                    .padding(.horizontal, 28)
                    .animation(.easeInOut(duration: 0.25), value: mostrarError)
                    .animation(.easeInOut(duration: 0.25), value: mensajeExito)

                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }

    // MARK: - Firebase Reset Password
    func recuperarContrasena() {

        guard !email.isEmpty else {
            errorMensaje = "Por favor ingresa tu correo electrónico."
            mostrarError = true
            return
        }

        guard email.contains("@") else {
            errorMensaje = "El formato del correo no es válido."
            mostrarError = true
            return
        }

        cargando = true
        mostrarError = false

        Auth.auth().sendPasswordReset(withEmail: email) { error in

            cargando = false

            if let error = error {
                let codigo = (error as NSError).code
                switch codigo {
                case 17008:
                    errorMensaje = "El formato del correo no es válido."
                case 17011:
                    errorMensaje = "No existe una cuenta con este correo."
                default:
                    errorMensaje = "Ocurrió un error, intenta de nuevo."
                }
                mostrarError = true
                return
            }

            mensajeExito = true
        }
    }
}

// MARK: - Vista Principal Login
struct IniciarSesionView: View {

    @State private var email = ""
    @State private var password = ""
    @State private var mostrarPassword = false
    @State private var recordar = false

    @State private var irAInicioHombre = false
    @State private var irAInicioMujer = false
    @State private var nombreUsuario: String = ""

    @State private var errorMensaje = ""
    @State private var mostrarError = false
    @State private var cargando = false

    // ← NUEVO: controla el sheet de recuperación
    @State private var mostrarRecuperar = false

    private let purpura = Color(red: 0.47, green: 0.38, blue: 0.93)
    private let azul    = Color(red: 0.20, green: 0.50, blue: 1.00)

    var body: some View {

        NavigationStack {

            ZStack {

                LinearGradient(
                    colors: [
                        Color(red: 0.97, green: 0.96, blue: 1.00),
                        Color(red: 0.93, green: 0.95, blue: 1.00)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                Circle()
                    .fill(purpura.opacity(0.09))
                    .frame(width: 320, height: 320)
                    .offset(x: 140, y: -220)

                Circle()
                    .fill(azul.opacity(0.07))
                    .frame(width: 260, height: 260)
                    .offset(x: -130, y: 380)

                Circle()
                    .fill(purpura.opacity(0.05))
                    .frame(width: 160, height: 160)
                    .offset(x: -80, y: -300)

                ScrollView {

                    VStack(spacing: 0) {

                        Spacer().frame(height: 60)

                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [purpura.opacity(0.15), azul.opacity(0.10)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 80, height: 80)

                            Image(systemName: "brain.head.profile")
                                .font(.system(size: 34, weight: .semibold))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [purpura, azul],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }
                        .padding(.bottom, 20)

                        VStack(spacing: 6) {
                            Text("Bienvenido de nuevo")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [purpura, azul],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )

                            Text("Inicia sesión para continuar")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        .padding(.bottom, 36)

                        VStack(alignment: .leading, spacing: 20) {

                            campoTexto(
                                titulo: "Email",
                                placeholder: "correo@email.com",
                                texto: $email,
                                icono: "envelope.fill",
                                esEmail: true
                            )

                            VStack(alignment: .leading, spacing: 8) {

                                Label("Contraseña", systemImage: "lock.fill")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color(red: 0.30, green: 0.30, blue: 0.40))

                                HStack {
                                    if mostrarPassword {
                                        TextField("Contraseña", text: $password)
                                            .font(.system(size: 16))
                                    } else {
                                        SecureField("••••••••", text: $password)
                                            .font(.system(size: 16))
                                    }

                                    Spacer()

                                    Button(action: { mostrarPassword.toggle() }) {
                                        Image(systemName: mostrarPassword ? "eye.fill" : "eye.slash.fill")
                                            .foregroundColor(.gray.opacity(0.5))
                                            .font(.system(size: 14))
                                    }
                                }
                                .padding(.horizontal, 16)
                                .frame(height: 54)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
                            }

                            HStack {

                                Button(action: { recordar.toggle() }) {
                                    HStack(spacing: 8) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 6)
                                                .stroke(recordar ? purpura : Color.gray.opacity(0.4), lineWidth: 1.5)
                                                .frame(width: 20, height: 20)

                                            if recordar {
                                                RoundedRectangle(cornerRadius: 6)
                                                    .fill(purpura)
                                                    .frame(width: 20, height: 20)
                                                Image(systemName: "checkmark")
                                                    .font(.system(size: 11, weight: .bold))
                                                    .foregroundColor(.white)
                                            }
                                        }

                                        Text("Recordarme")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 14))
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())

                                Spacer()

                                // ← CAMBIO: ahora abre el sheet
                                Button(action: { mostrarRecuperar = true }) {
                                    Text("¿Olvidaste tu contraseña?")
                                        .foregroundStyle(
                                            LinearGradient(
                                                colors: [purpura, azul],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .font(.system(size: 14, weight: .semibold))
                                }
                            }
                            .padding(.top, 2)

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

                            Button(action: iniciarSesion) {
                                ZStack {
                                    Text("Iniciar Sesión")
                                        .foregroundColor(.white)
                                        .font(.system(size: 17, weight: .bold))
                                        .opacity(cargando ? 0 : 1)

                                    if cargando { ProgressView().tint(.white) }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(
                                LinearGradient(
                                    colors: [purpura, azul],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: purpura.opacity(0.40), radius: 12, x: 0, y: 6)
                            .padding(.top, 8)

                            HStack(spacing: 12) {
                                Rectangle().fill(Color.gray.opacity(0.2)).frame(height: 1)
                                Text("o").font(.system(size: 13)).foregroundColor(.gray.opacity(0.6))
                                Rectangle().fill(Color.gray.opacity(0.2)).frame(height: 1)
                            }
                            .padding(.vertical, 4)

                            HStack {
                                Spacer()
                                Text("¿No tienes una cuenta?")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 15))

                                NavigationLink(destination: CrearCuentaView()) {
                                    Text("Regístrate")
                                        .foregroundStyle(
                                            LinearGradient(
                                                colors: [purpura, azul],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .font(.system(size: 15, weight: .bold))
                                }
                                Spacer()
                            }
                        }
                        .padding(.horizontal, 28)

                        Spacer().frame(height: 40)
                    }
                }
            }
            .animation(.easeInOut(duration: 0.25), value: mostrarError)

            // ← NUEVO: sheet de recuperación
            .sheet(isPresented: $mostrarRecuperar) {
                RecuperarContrasenaView()
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }

            .navigationDestination(isPresented: $irAInicioMujer) {
                MenuView(nombreUsuario: nombreUsuario, genero: "mujer", onCerrarSesion: cerrarSesion)
            }
            .navigationDestination(isPresented: $irAInicioHombre) {
                MenuView(nombreUsuario: nombreUsuario, genero: "hombre", onCerrarSesion: cerrarSesion)
            }
        }
    }

    // MARK: - Campo reutilizable
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
                .textInputAutocapitalization(.never)
                #endif
                .autocorrectionDisabled()
                .font(.system(size: 16))
                .padding(.horizontal, 16)
                .frame(height: 54)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
        }
    }

    // MARK: - Firebase Login
    func iniciarSesion() {

        guard !email.isEmpty, !password.isEmpty else {
            errorMensaje = "Por favor ingresa tu email y contraseña."
            mostrarError = true
            return
        }

        cargando = true
        mostrarError = false

        Auth.auth().signIn(withEmail: email, password: password) { result, error in

            if let error = error {
                cargando = false
                errorMensaje = traducirError(error)
                mostrarError = true
                return
            }

            guard let uid = result?.user.uid else { return }

            Firestore.firestore()
                .collection("usuarios")
                .document(uid)
                .getDocument { doc, error in

                    cargando = false

                    let genero = doc?.data()?["genero"] as? String ?? "mujer"
                    let nombre = doc?.data()?["nombre"] as? String ?? "Usuario"

                    self.nombreUsuario = nombre

                    if genero == "hombre" {
                        irAInicioHombre = true
                    } else {
                        irAInicioMujer = true
                    }
                }
        }
    }

    // MARK: - Logout
    private func cerrarSesion() {
        irAInicioMujer = false
        irAInicioHombre = false
        try? Auth.auth().signOut()
    }

    // MARK: - Traductor errores Firebase
    func traducirError(_ error: Error) -> String {

        let codigo = (error as NSError).code

        switch codigo {
        case 17004: return "Credenciales incorrectas, verifica tu email y contraseña"
        case 17007: return "Este correo ya está registrado"
        case 17008: return "El formato del correo no es válido"
        case 17009: return "La contraseña es incorrecta"
        case 17011: return "No existe una cuenta con este correo"
        case 17026: return "La contraseña debe tener al menos 6 caracteres"
        case 17999: return "Ocurrió un error inesperado, intenta de nuevo"
        default:    return "Ocurrió un error, intenta de nuevo"
        }
    }
}

#Preview {
    IniciarSesionView()
}
