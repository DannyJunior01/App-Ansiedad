import SwiftUI

struct BienvenidaView: View {

    @State private var mostrarLogin = false

    @State private var mostrarMemoji1  = false
    @State private var mostrarPerfil   = false
    @State private var mostrarNombre   = false
    @State private var mostrarMemoji3  = false
    @State private var mostrarInferior = false
    @State private var mostrarBotones  = false
    @State private var pulsarPerfil    = false

    private let azul      = Color(red: 0.20, green: 0.45, blue: 1.00)
    private let azulMedio = Color(red: 0.30, green: 0.55, blue: 1.00)
    private let azulClaro = Color(red: 0.55, green: 0.75, blue: 1.00)
    private let morado    = Color(red: 0.45, green: 0.35, blue: 0.95)

    var body: some View {

        Group {

            if mostrarLogin {

                IniciarSesionView()

            } else {

                ZStack(alignment: .bottom) {

                    // ── Fondo continuo blanco → azul ──────────────────────
                    LinearGradient(
                        stops: [
                            .init(color: .white,                               location: 0.00),
                            .init(color: .white,                               location: 0.30),
                            .init(color: Color(red:0.93,green:0.95,blue:1.0),  location: 0.38),
                            .init(color: Color(red:0.82,green:0.88,blue:1.0),  location: 0.44),
                            .init(color: Color(red:0.68,green:0.80,blue:1.0),  location: 0.50),
                            .init(color: Color(red:0.50,green:0.68,blue:1.0),  location: 0.56),
                            .init(color: Color(red:0.35,green:0.58,blue:1.0),  location: 0.62),
                            .init(color: azulMedio,                            location: 0.70),
                            .init(color: azul,                                 location: 0.80),
                            .init(color: Color(red:0.10,green:0.28,blue:0.88), location: 1.00)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()

                    VStack(spacing: 0) {

                        Spacer()

                        // ── Zona blanca: tres filas ───────────────────────
                        VStack(alignment: .leading, spacing: 10) {

                            // Fila 1: memoji alegría
                            HStack {
                                Image("memoji alegria")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 90, height: 90)
                                    .opacity(mostrarMemoji1 ? 0.28 : 0)
                                    .blur(radius: mostrarMemoji1 ? 2 : 8)
                                    .offset(x: mostrarMemoji1 ? 0 : -40)
                            }

                            // Fila 2: perfil boy + nombre
                            HStack(spacing: 16) {
                                Image("perfil boy")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 130, height: 130)
                                    .shadow(color: azul.opacity(0.2), radius: 10, y: 4)
                                    .opacity(mostrarPerfil ? 1 : 0)
                                    .scaleEffect(mostrarPerfil ? (pulsarPerfil ? 1.04 : 1.0) : 0.6)
                                    .offset(y: mostrarPerfil ? 0 : 30)

                                Text("Getsemaní")
                                    .font(.system(size: 37, weight: .bold, design: .rounded))
                                    .foregroundColor(.black)
                                    .opacity(mostrarNombre ? 1 : 0)
                                    .offset(x: mostrarNombre ? 0 : 30)
                            }

                            
                            HStack {
                                Image("memoji triste")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 90, height: 90)
                                    .opacity(mostrarMemoji3 ? 0.28 : 0)
                                    .blur(radius: mostrarMemoji3 ? 2 : 8)
                                    .offset(x: mostrarMemoji3 ? 0 : -40)
                            }
                        }
                        .padding(.leading, 32)
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Spacer()

                        // ── Sección azul inferior ─────────────────────────
                        VStack(alignment: .leading, spacing: 0) {

                            // Título
                            Text("Tu apoyo,\nemocional")
                                .font(.system(size: 34, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .lineSpacing(2)
                                .padding(.bottom, 8)
                                .opacity(mostrarInferior ? 1 : 0)
                                .offset(y: mostrarInferior ? 0 : 24)

                            // Subtítulo
                            Text("Respira, conecta y mejora\nun día a la vez ")
                                .font(.system(size: 15))
                                .foregroundColor(.white.opacity(0.70))
                                .padding(.bottom, 30)
                                .opacity(mostrarInferior ? 1 : 0)
                                .offset(y: mostrarInferior ? 0 : 18)

                            // Botón Continuar
                            Button {
                                withAnimation(.easeInOut(duration: 0.35)) {
                                    mostrarLogin = true
                                }
                            } label: {
                                HStack(spacing: 10) {
                                    Image(systemName: "arrow.right.circle.fill")
                                        .font(.system(size: 20))
                                    Text("Continuar")
                                        .font(.system(size: 17, weight: .semibold))
                                }
                                .foregroundColor(Color(red: 0.10, green: 0.25, blue: 0.88))
                                .frame(maxWidth: .infinity)
                                .frame(height: 58)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                            }
                            .opacity(mostrarBotones ? 1 : 0)
                            .offset(y: mostrarBotones ? 0 : 20)
                            .scaleEffect(mostrarBotones ? 1 : 0.95)

                            // Botón Ya tengo cuenta
                            Button {
                                withAnimation(.easeInOut(duration: 0.35)) {
                                    mostrarLogin = true
                                }
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: "person.crop.circle")
                                        .font(.system(size: 16))
                                    Text("Ya tengo cuenta")
                                        .font(.system(size: 16, weight: .medium))
                                }
                                .foregroundColor(.white.opacity(0.85))
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(.white.opacity(0.12))
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(.white.opacity(0.20), lineWidth: 1)
                                )
                            }
                            .padding(.top, 12)
                            .opacity(mostrarBotones ? 1 : 0)
                            .offset(y: mostrarBotones ? 0 : 20)
                            .scaleEffect(mostrarBotones ? 1 : 0.95)
                        }
                        .padding(.horizontal, 28)
                        .padding(.bottom, 52)
                    }
                }
                .ignoresSafeArea(edges: .bottom)
                .onAppear {
                    // Memoji alegría — entra desde la izquierda
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.75).delay(0.1)) {
                        mostrarMemoji1 = true
                    }
                    // Perfil boy — sube con rebote
                    withAnimation(.spring(response: 0.7, dampingFraction: 0.65).delay(0.3)) {
                        mostrarPerfil = true
                    }
                    // Nombre — desliza desde la derecha
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.75).delay(0.45)) {
                        mostrarNombre = true
                    }
                    // Memoji triste — entra desde la izquierda
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.75).delay(0.55)) {
                        mostrarMemoji3 = true
                    }
                    // Sección inferior — sube suave
                    withAnimation(.easeOut(duration: 0.55).delay(0.65)) {
                        mostrarInferior = true
                    }
                    // Botones — aparecen últimos
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.72).delay(0.8)) {
                        mostrarBotones = true
                    }
                    // Pulso sutil continuo en el perfil boy
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        withAnimation(
                            .easeInOut(duration: 1.8)
                            .repeatForever(autoreverses: true)
                        ) {
                            pulsarPerfil = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    BienvenidaView()
}
