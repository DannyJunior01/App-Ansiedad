import SwiftUI

// MARK: - Modelo
struct Frase: Identifiable {
    let id = UUID()
    let texto: String
    let autor: String
    let categoria: String
}

// MARK: - FrasesView
struct FrasesView: View {

    let nombreUsuario: String
    let genero: String

    private let purpura  = Color(red: 101/255, green: 89/255,  blue: 255/255)
    private let violeta  = Color(red: 169/255, green: 102/255, blue: 255/255)

    @State private var categoriaSeleccionada = "Motivación"
    @State private var animarHeader          = false
    @State private var animarParticulas      = false
    @State private var cardAparecer          = false
    @State private var fraseDestacadaIndex  = 0

    var imagenPerfil: String { genero == "hombre" ? "perfil boy" : "perfil" }

    let categorias: [(nombre: String, emoji: String, colores: [Color])] = [
        ("Motivación", "", [Color(red: 255/255, green: 149/255, blue: 0/255),
                               Color(red: 255/255, green: 89/255,  blue: 80/255)]),
        ("Gratitud",   "", [Color(red: 169/255, green: 102/255, blue: 255/255),
                               Color(red: 101/255, green: 89/255,  blue: 255/255)]),
        ("Calma",      "", [Color(red: 64/255,  green: 156/255, blue: 255/255),
                               Color(red: 52/255,  green: 199/255, blue: 141/255)]),
        ("Espiritual", "", [Color(red: 90/255,  green: 70/255,  blue: 180/255),
                               Color(red: 140/255, green: 100/255, blue: 220/255)])
    ]

    // MARK: - Base de frases
    let todasLasFrases: [Frase] = [

        // ── MOTIVACIÓN ──────────────────────────────────────────
        Frase(texto: "El que tiene un porqué para vivir puede soportar casi cualquier cómo.",
              autor: "Viktor Frankl", categoria: "Motivación"),
        Frase(texto: "Entre el estímulo y la respuesta hay un espacio. En ese espacio está nuestro poder para elegir.",
              autor: "Viktor Frankl", categoria: "Motivación"),
        Frase(texto: "La grandeza no consiste en nunca caer, sino en levantarse cada vez que caemos.",
              autor: "Nelson Mandela", categoria: "Motivación"),
        Frase(texto: "No es la montaña la que conquistamos, sino a nosotros mismos.",
              autor: "Sir Edmund Hillary", categoria: "Motivación"),
        Frase(texto: "El único modo de hacer un gran trabajo es amar lo que haces.",
              autor: "Steve Jobs", categoria: "Motivación"),
        Frase(texto: "Haz cada día algo que te asuste. Así es como creces.",
              autor: "Eleanor Roosevelt", categoria: "Motivación"),
        Frase(texto: "Caer está permitido. Levantarse es obligatorio.",
              autor: "Mary Pickford", categoria: "Motivación"),
        Frase(texto: "El éxito no es la clave de la felicidad. La felicidad es la clave del éxito.",
              autor: "Albert Schweitzer", categoria: "Motivación"),
        Frase(texto: "Primero, dite a ti mismo quién quieres ser; luego haz lo que tengas que hacer.",
              autor: "Epicteto", categoria: "Motivación"),
        Frase(texto: "La vida no se mide por los momentos que respiras, sino por los que te quitan el aliento.",
              autor: "Maya Angelou", categoria: "Motivación"),
        Frase(texto: "No cuentes los días. Haz que los días cuenten.",
              autor: "Muhammad Ali", categoria: "Motivación"),
        Frase(texto: "Cree en ti mismo y llegará un día en que los demás no tendrán más remedio que creer en ti.",
              autor: "Cynthia Kersey", categoria: "Motivación"),

        // ── GRATITUD ─────────────────────────────────────────────
        Frase(texto: "Si lo único que hicieras fuera dar gracias, eso sería suficiente.",
              autor: "Meister Eckhart", categoria: "Gratitud"),
        Frase(texto: "La gratitud convierte lo que tenemos en suficiente.",
              autor: "Melodie Beattie", categoria: "Gratitud"),
        Frase(texto: "No es la felicidad lo que nos hace agradecidos; es la gratitud la que nos hace felices.",
              autor: "David Steindl-Rast", categoria: "Gratitud"),
        Frase(texto: "Sé agradecido por lo que tienes; tendrás más. Si te concentras en lo que no tienes, nunca tendrás suficiente.",
              autor: "Oprah Winfrey", categoria: "Gratitud"),
        Frase(texto: "La gratitud es la memoria del corazón.",
              autor: "Jean Baptiste Massieu", categoria: "Gratitud"),
        Frase(texto: "Un corazón agradecido es un corazón abierto.",
              autor: "Brené Brown", categoria: "Gratitud"),
        Frase(texto: "Cuando comes una fruta, recuerda al que plantó el árbol.",
              autor: "Proverbio vietnamita", categoria: "Gratitud"),
        Frase(texto: "El agradecimiento no solo es la mayor de las virtudes, sino la madre de todas las demás.",
              autor: "Cicerón", categoria: "Gratitud"),
        Frase(texto: "Dar gracias es bueno; compartir lo que tienes es mejor.",
              autor: "Proverbio africano", categoria: "Gratitud"),
        Frase(texto: "Apreciar lo pequeño es el comienzo de una vida grande.",
              autor: "G.K. Chesterton", categoria: "Gratitud"),

        // ── CALMA ────────────────────────────────────────────────
        Frase(texto: "La paz no es la ausencia del conflicto, sino la capacidad de manejarlo con calma.",
              autor: "Dalai Lama", categoria: "Calma"),
        Frase(texto: "La mente tranquila es el tesoro más preciado que existe.",
              autor: "Lao Tzu", categoria: "Calma"),
        Frase(texto: "Respira. Eres suficiente. Estás a salvo. Este momento pasará.",
              autor: "Thich Nhat Hanh", categoria: "Calma"),
        Frase(texto: "No sufras por lo que no existe todavía. No anticipes problemas. La preocupación es interés pagado por una deuda que quizás nunca tengas.",
              autor: "Mark Twain", categoria: "Calma"),
        Frase(texto: "En el silencio encontrarás lo que necesitas.",
              autor: "Eckhart Tolle", categoria: "Calma"),
        Frase(texto: "Conserva la calma. Incluso el mar, en su mayor tormenta, tiene un fondo quieto.",
              autor: "Rumi", categoria: "Calma"),
        Frase(texto: "La serenidad no consiste en estar en un lugar sin ruido, sino en estar en medio del caos y seguir en paz.",
              autor: "Anónimo", categoria: "Calma"),
        Frase(texto: "No puedes calmar la tormenta, así que deja de intentarlo. Cálmate tú y la tormenta pasará.",
              autor: "Timber Hawkeye", categoria: "Calma"),
        Frase(texto: "Si el problema tiene solución, ¿para qué preocuparse? Y si no la tiene, ¿para qué preocuparse?",
              autor: "Proverbio tibetano", categoria: "Calma"),
        Frase(texto: "Haz lo que puedas, con lo que tienes, donde estás.",
              autor: "Theodore Roosevelt", categoria: "Calma"),

        // ── ESPIRITUAL ───────────────────────────────────────────
        Frase(texto: "Todo lo puedo en Cristo que me fortalece.",
              autor: "Filipenses 4:13", categoria: "Espiritual"),
        Frase(texto: "El Señor es mi pastor, nada me faltará.",
              autor: "Salmo 23:1", categoria: "Espiritual"),
        Frase(texto: "Porque yo sé los planes que tengo para ustedes: planes de bienestar y no de calamidad, para darles un futuro y una esperanza.",
              autor: "Jeremías 29:11", categoria: "Espiritual"),
        Frase(texto: "Sean fuertes y valientes. No teman ni se asusten, porque el Señor su Dios estará con ustedes donde quiera que vayan.",
              autor: "Josué 1:9", categoria: "Espiritual"),
        Frase(texto: "El amor es paciente, es bondadoso. El amor no tiene envidia, no es presumido ni orgulloso.",
              autor: "1 Corintios 13:4", categoria: "Espiritual"),
        Frase(texto: "Confía en el Señor con todo tu corazón, y no te apoyes en tu propia prudencia.",
              autor: "Proverbios 3:5", categoria: "Espiritual"),
        Frase(texto: "Pide y se te dará; busca y encontrarás; llama y la puerta se te abrirá.",
              autor: "Mateo 7:7", categoria: "Espiritual"),
        Frase(texto: "Fuera está la oscuridad; dentro, incluso en lo más profundo del infierno, hay luz.",
              autor: "Rumi", categoria: "Espiritual"),
        Frase(texto: "Tu tarea no es buscar el amor, sino simplemente buscar y encontrar todas las barreras dentro de ti que has construido contra él.",
              autor: "Rumi", categoria: "Espiritual"),
        Frase(texto: "El alma siempre sabe cómo sanar. El reto es silenciar la mente.",
              autor: "Caroline Myss", categoria: "Espiritual"),
        Frase(texto: "El universo no es una prueba que debes pasar. Es un hogar al que perteneces.",
              autor: "Alan Watts", categoria: "Espiritual"),
        Frase(texto: "Dentro de ti hay una quietud y un santuario al que puedes retirarte en cualquier momento.",
              autor: "Hermann Hesse", categoria: "Espiritual")
    ]

    var frasesFiltradas: [Frase] {
        todasLasFrases.filter { $0.categoria == categoriaSeleccionada }
    }

    var coloresCategoria: [Color] {
        categorias.first(where: { $0.nombre == categoriaSeleccionada })?.colores
            ?? [purpura, violeta]
    }

    var emojiCategoria: String {
        categorias.first(where: { $0.nombre == categoriaSeleccionada })?.emoji ?? "✨"
    }

    var body: some View {
        ZStack {
            // Fondo dinámico suave
            LinearGradient(
                colors: [
                    coloresCategoria[0].opacity(0.08),
                    Color(red: 245/255, green: 245/255, blue: 248/255)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.6), value: categoriaSeleccionada)

            // Partículas decorativas
            particulasFlotantes

            ScrollView(showsIndicators: false) {
                VStack(spacing: 22) {

                    headerPersonalizado
                    selectorCategorias
                    fraseDestacadaCard
                    listaFrases

                }
                .padding(.bottom, 110)
            }
        }
        .onAppear {
            animarHeader    = true
            animarParticulas = true
        }
    }

    // MARK: - Partículas flotantes
    private var particulasFlotantes: some View {
        GeometryReader { geo in
            ForEach(0..<6, id: \.self) { i in
                Circle()
                    .fill(coloresCategoria[i % 2].opacity(0.06))
                    .frame(width: CGFloat([80, 55, 100, 65, 45, 90][i]))
                    .offset(
                        x: CGFloat([30, 280, 10, 300, 150, 250][i]),
                        y: animarParticulas
                            ? CGFloat([100, 200, 400, 350, 550, 650][i])
                            : CGFloat([120, 220, 420, 370, 570, 670][i])
                    )
                    .animation(
                        .easeInOut(duration: Double([3.5, 4.2, 3.8, 5.0, 4.5, 3.2][i]))
                        .repeatForever(autoreverses: true)
                        .delay(Double(i) * 0.4),
                        value: animarParticulas
                    )
            }
        }
        .ignoresSafeArea()
    }

    // MARK: - Header personalizado
    private var headerPersonalizado: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(colors: coloresCategoria,
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing)
                    )
                    .frame(width: 62, height: 62)
                    .shadow(color: coloresCategoria[0].opacity(0.4), radius: 10, y: 4)
                    .animation(.easeInOut(duration: 0.6), value: categoriaSeleccionada)

                Image(imagenPerfil)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 54, height: 54)
                    .clipShape(Circle())
            }
            .scaleEffect(animarHeader ? 1.0 : 0.7)
            .opacity(animarHeader ? 1.0 : 0)
            .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.1), value: animarHeader)

            VStack(alignment: .leading, spacing: 3) {
                Text("Hola, \(nombreUsuario) ")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.black.opacity(0.88))
                Text("Estas frases son para ti")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(.gray)
            }
            .offset(x: animarHeader ? 0 : -20)
            .opacity(animarHeader ? 1.0 : 0)
            .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.2), value: animarHeader)

            Spacer()

            Text(emojiCategoria)
                .font(.system(size: 32))
                .scaleEffect(animarHeader ? 1.0 : 0.5)
                .opacity(animarHeader ? 1.0 : 0)
                .animation(.spring(response: 0.4, dampingFraction: 0.6).delay(0.3), value: animarHeader)
                .animation(.easeInOut(duration: 0.4), value: emojiCategoria)
        }
        .padding(.horizontal, 22)
        .padding(.top, 20)
    }

    // MARK: - Selector de categorías
    private var selectorCategorias: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(categorias, id: \.nombre) { cat in
                    let seleccionada = categoriaSeleccionada == cat.nombre
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                            categoriaSeleccionada = cat.nombre
                            cardAparecer = false
                            fraseDestacadaIndex = 0
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation { cardAparecer = true }
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Text(cat.emoji)
                                .font(.system(size: 15))
                            Text(cat.nombre)
                                .font(.system(size: 14, weight: seleccionada ? .bold : .medium,
                                              design: .rounded))
                                .foregroundColor(seleccionada ? .white : .black.opacity(0.7))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            Group {
                                if seleccionada {
                                    LinearGradient(colors: cat.colores,
                                                   startPoint: .leading,
                                                   endPoint: .trailing)
                                } else {
                                    LinearGradient(colors: [Color.white, Color.white],
                                                   startPoint: .leading,
                                                   endPoint: .trailing)
                                }
                            }
                        )
                        .clipShape(Capsule())
                        .shadow(
                            color: seleccionada ? cat.colores[0].opacity(0.35) : .black.opacity(0.06),
                            radius: seleccionada ? 10 : 4, y: 3
                        )
                        .scaleEffect(seleccionada ? 1.05 : 1.0)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 4)
        }
    }

    // MARK: - Frase destacada (auto-rotante)
    private var fraseDestacadaCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28)
                .fill(LinearGradient(colors: coloresCategoria,
                                     startPoint: .topLeading,
                                     endPoint: .bottomTrailing))
                .shadow(color: coloresCategoria[0].opacity(0.35), radius: 20, y: 10)

            // Decoración interna
            Circle().fill(Color.white.opacity(0.07)).frame(width: 150).offset(x: -100, y: -40)
            Circle().fill(Color.white.opacity(0.05)).frame(width: 100).offset(x: 130, y: 60)
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                .padding(8)

            if frasesFiltradas.indices.contains(fraseDestacadaIndex) {
                let frase = frasesFiltradas[fraseDestacadaIndex]
                VStack(alignment: .leading, spacing: 14) {

                    HStack {
                        Label("FRASE DESTACADA", systemImage: "star.fill")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .tracking(1.6)
                            .foregroundColor(.white.opacity(0.8))
                        Spacer()
                        // Indicadores de página
                        HStack(spacing: 5) {
                            ForEach(0..<min(frasesFiltradas.count, 5), id: \.self) { i in
                                Circle()
                                    .fill(Color.white.opacity(i == fraseDestacadaIndex % 5 ? 1.0 : 0.3))
                                    .frame(width: i == fraseDestacadaIndex % 5 ? 8 : 5,
                                           height: i == fraseDestacadaIndex % 5 ? 8 : 5)
                                    .animation(.spring(response: 0.3), value: fraseDestacadaIndex)
                            }
                        }
                    }

                    Text("❝")
                        .font(.system(size: 40))
                        .foregroundColor(.white.opacity(0.3))
                        .offset(y: -8)

                    Text(frase.texto)
                        .font(.system(size: 19, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .lineSpacing(6)
                        .fixedSize(horizontal: false, vertical: true)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal:   .move(edge: .leading).combined(with: .opacity)
                        ))
                        .id("frase-\(fraseDestacadaIndex)")

                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("— \(frase.autor)")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundColor(.white.opacity(0.9))
                            Text("Para ti, \(nombreUsuario)")
                                .font(.system(size: 12, design: .rounded))
                                .foregroundColor(.white.opacity(0.65))
                        }
                        Spacer()
                        // Botón siguiente
                        Button {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                                fraseDestacadaIndex = (fraseDestacadaIndex + 1) % frasesFiltradas.count
                            }
                        } label: {
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(24)
            }
        }
        .frame(minHeight: 220)
        .padding(.horizontal, 20)
        .animation(.easeInOut(duration: 0.5), value: categoriaSeleccionada)
    }

    // MARK: - Lista de frases
    private var listaFrases: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Todas las frases")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                Spacer()
                Text("\(frasesFiltradas.count) frases")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 22)

            ForEach(Array(frasesFiltradas.enumerated()), id: \.element.id) { index, frase in
                fraseRow(frase: frase, index: index)
            }
        }
    }

    @ViewBuilder
    private func fraseRow(frase: Frase, index: Int) -> some View {
        let esDestacada = index == fraseDestacadaIndex
        let color = coloresCategoria[index % 2]

        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 10, y: 4)

            // Barra lateral de color
            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(LinearGradient(colors: coloresCategoria,
                                         startPoint: .top, endPoint: .bottom))
                    .frame(width: 4)
                    .padding(.vertical, 16)
                    .padding(.leading, 14)

                VStack(alignment: .leading, spacing: 8) {
                    Text(frase.texto)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(.black.opacity(0.85))
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)

                    HStack {
                        Image(systemName: "person.fill")
                            .font(.system(size: 10))
                            .foregroundColor(color)
                        Text(frase.autor)
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundColor(color)
                        Spacer()
                        if esDestacada {
                            Label("Destacada", systemImage: "star.fill")
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .foregroundColor(color)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Capsule().fill(color.opacity(0.12)))
                        }
                    }
                }
                .padding(.leading, 12)
                .padding(.trailing, 16)
                .padding(.vertical, 16)
            }
        }
        .padding(.horizontal, 20)
        .scaleEffect(esDestacada ? 1.02 : 1.0)
        .animation(.spring(response: 0.3), value: esDestacada)
        .onTapGesture {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                fraseDestacadaIndex = index
            }
        }
    }

    // MARK: - Timer auto-rotación
   
}

#Preview {
    FrasesView(nombreUsuario: "Carla", genero: "mujer")
}
