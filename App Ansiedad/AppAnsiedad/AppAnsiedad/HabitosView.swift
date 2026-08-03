import SwiftUI

// MARK: - Modelo

enum AnimacionHabito {
    case respiracion
    case meditacion
    case ejercicio
    case general
}

struct HabitoContenido: Identifiable {
    let id: String
    let titulo: String
    let subtitulo: String
    let imagen: String
    let icono: String
    let color: Color
    let intro: String
    let tipDestacado: String
    let consejos: [String]
    let tipoAnimacion: AnimacionHabito
}

// MARK: - Catálogo

enum HabitoCatalog {
    static let todos: [HabitoContenido] = [
        HabitoContenido(
            id: "meditacion",
            titulo: "Meditación",
            subtitulo: "Calma tu mente",
            imagen: "imagen meditar",
            icono: "sparkles",
            color: Color(red: 140/255, green: 100/255, blue: 255/255),
            intro: "", tipDestacado: "", consejos: [],
            tipoAnimacion: .meditacion
        ),
        HabitoContenido(
            id: "respiracion",
            titulo: "Respiración",
            subtitulo: "Respira profundo",
            imagen: "imagen respirar",
            icono: "wind",
            color: Color(red: 90/255, green: 170/255, blue: 255/255),
            intro: "", tipDestacado: "", consejos: [],
            tipoAnimacion: .respiracion
        ),
        HabitoContenido(
            id: "ejercicio",
            titulo: "Ejercicio",
            subtitulo: "Mueve tu cuerpo",
            imagen: "imagen correr",
            icono: "figure.run",
            color: Color(red: 52/255, green: 199/255, blue: 141/255),
            intro: "", tipDestacado: "", consejos: [],
            tipoAnimacion: .ejercicio
        ),
        HabitoContenido(
            id: "leer",
            titulo: "Leer",
            subtitulo: "Un momento tranquilo",
            imagen: "imagen leer",
            icono: "book.fill",
            color: Color(red: 255/255, green: 149/255, blue: 0/255),
            intro: "", tipDestacado: "", consejos: [],
            tipoAnimacion: .general
        ),
        HabitoContenido(
            id: "musica",
            titulo: "Música",
            subtitulo: "Relaja tu mente",
            imagen: "imagen musica",
            icono: "headphones",
            color: Color(red: 255/255, green: 110/255, blue: 160/255),
            intro: "", tipDestacado: "", consejos: [],
            tipoAnimacion: .general
        ),
        HabitoContenido(
            id: "naturaleza",
            titulo: "Naturaleza",
            subtitulo: "Conecta contigo",
            imagen: "imagen naturaleza",
            icono: "leaf.fill",
            color: Color(red: 90/255, green: 190/255, blue: 120/255),
            intro: "", tipDestacado: "", consejos: [],
            tipoAnimacion: .general
        )
    ]
}

// MARK: - Chip Model

struct ChipHabito {
    let titulo: String
    let icono: String
    let habitoId: String
}

// MARK: - Vista Principal

struct HabitosView: View {

    let nombreUsuario: String
    let memojiNombre: String

    @State private var habitoSeleccionado: HabitoContenido?
    @State private var irDetalle        = false
    @State private var habitoPresionado: String?
    @State private var animarHeader     = false
    @State private var animarCards      = false
    @State private var chipActivo: String? = nil

    private let fondo   = Color(red: 245/255, green: 245/255, blue: 248/255)
    private let purpura = Color(red: 101/255, green:  89/255, blue: 255/255)
    private let violeta = Color(red: 169/255, green: 102/255, blue: 255/255)
    private let habitos = HabitoCatalog.todos

    private let chips: [ChipHabito] = [
        ChipHabito(titulo: "Meditación",  icono: "sparkles",   habitoId: "meditacion"),
        ChipHabito(titulo: "Respiración", icono: "wind",        habitoId: "respiracion"),
        ChipHabito(titulo: "Ejercicio",   icono: "figure.run",  habitoId: "ejercicio"),
        ChipHabito(titulo: "Lectura",     icono: "book.fill",   habitoId: "leer"),
        ChipHabito(titulo: "Música",      icono: "headphones",  habitoId: "musica"),
        ChipHabito(titulo: "Naturaleza",  icono: "leaf.fill",   habitoId: "naturaleza")
    ]

    private var habitosFiltrados: [HabitoContenido] {
        guard let id = chipActivo else { return habitos }
        return habitos.filter { $0.id == id }
    }

    private var colorActivo: Color {
        guard let id = chipActivo,
              let h = habitos.first(where: { $0.id == id })
        else { return purpura }
        return h.color
    }

    private var colorActivoSecundario: Color {
        guard let id = chipActivo,
              let h = habitos.first(where: { $0.id == id })
        else { return violeta }
        return h.color.opacity(0.7)
    }

    var body: some View {
        NavigationStack {
            ZStack {

                LinearGradient(
                    colors: [colorActivo.opacity(0.10), fondo, Color.white],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.5), value: chipActivo)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 26) {

                        header
                        categoriasFitness

                        if chipActivo == nil {
                            heroCard
                            seccionTitulo(
                                titulo: "Para ti",
                                subtitulo: "Rutinas para sentirte mejor"
                            )
                            VStack(spacing: 18) {
                                ForEach(
                                    Array(habitosFiltrados.dropFirst().enumerated()),
                                    id: \.element.id
                                ) { index, habito in
                                    tarjetaHorizontal(habito, index: index)
                                }
                            }
                        } else {
                            habitoFiltradoDestacado
                        }

                        Spacer(minLength: 120)
                    }
                    .padding(.top, 12)
                }

                NavigationLink(
                    destination: Group {
                        if let habito = habitoSeleccionado {
                            HabitoDetalleView(
                                habito: habito,
                                nombreUsuario: nombreUsuario
                            )
                        }
                    },
                    isActive: $irDetalle
                ) { EmptyView() }
                .hidden()
            }
        }
        // ── Animación igual que FrasesView: sin withAnimation, ──
        // ── directo al state, el modifier lleva el timing      ──
        .onAppear {
            animarHeader = true
            animarCards  = true
        }
    }
}

// MARK: - Header

extension HabitosView {

    private var header: some View {
        HStack(spacing: 14) {

            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [colorActivo, colorActivoSecundario],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 62, height: 62)
                    .shadow(color: colorActivo.opacity(0.40), radius: 10, y: 4)
                    .animation(.easeInOut(duration: 0.45), value: chipActivo)

                Image(memojiNombre)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 54, height: 54)
                    .clipShape(Circle())
            }
            .scaleEffect(animarHeader ? 1.0 : 0.7)
            .opacity(animarHeader ? 1.0 : 0)
            .animation(
                .spring(response: 0.5, dampingFraction: 0.7).delay(0.1),
                value: animarHeader
            )

            VStack(alignment: .leading, spacing: 3) {
                Text("Hola, \(nombreUsuario)")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.black.opacity(0.88))

                Text("Estos hábitos son para ti")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(.gray)
            }
            .offset(x: animarHeader ? 0 : -20)
            .opacity(animarHeader ? 1.0 : 0)
            .animation(
                .spring(response: 0.5, dampingFraction: 0.8).delay(0.2),
                value: animarHeader
            )

            Spacer()
        }
        .padding(.horizontal, 22)
        .padding(.top, 20)
    }
}

// MARK: - Chips

extension HabitosView {

    private var categoriasFitness: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(chips, id: \.habitoId) { chip in
                    chipView(chip)
                }
            }
            .padding(.horizontal, 20)
        }
    }

    private func chipView(_ chip: ChipHabito) -> some View {
        let estaActivo = chipActivo == chip.habitoId
        let colorChip  = habitos.first(where: { $0.id == chip.habitoId })?.color ?? purpura

        return Button {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
                chipActivo = estaActivo ? nil : chip.habitoId
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: chip.icono)
                    .font(.system(size: 12, weight: .bold))
                Text(chip.titulo.uppercased())
                    .font(.system(size: 11, weight: .bold, design: .rounded))
            }
            .foregroundColor(estaActivo ? .white : .black.opacity(0.75))
            .padding(.horizontal, 16)
            .padding(.vertical, 11)
            .background(estaActivo ? colorChip : Color.white)
            .clipShape(Capsule())
            .shadow(
                color: estaActivo ? colorChip.opacity(0.40) : .black.opacity(0.05),
                radius: estaActivo ? 10 : 8,
                y: 4
            )
            .scaleEffect(estaActivo ? 1.04 : 1.0)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Hábito Destacado (chip activo)

extension HabitosView {

    @ViewBuilder
    private var habitoFiltradoDestacado: some View {
        if let habito = habitosFiltrados.first {
            VStack(spacing: 20) {

                Button { abrirHabito(habito) } label: {

                    // ── Imagen + overlay de color del hábito ─────
                    ZStack(alignment: .bottomLeading) {

                        // Imagen real del hábito
                        Image(habito.imagen)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 300)
                            .frame(maxWidth: .infinity)
                            .clipped()

                        // Overlay con el color propio del hábito
                        LinearGradient(
                            colors: [
                                habito.color.opacity(0.15),
                                habito.color.opacity(0.80)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )

                        // Contenido sobre la imagen
                        VStack(alignment: .leading, spacing: 12) {

                            HStack {
                                // Icono del hábito
                                ZStack {
                                    Circle()
                                        .fill(Color.white.opacity(0.22))
                                        .frame(width: 38, height: 38)
                                    Image(systemName: habito.icono)
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                }

                                Spacer()

                                // Badge
                                Text("Hábito activo")
                                    .font(.system(size: 11, weight: .bold, design: .rounded))
                                    .foregroundColor(.white.opacity(0.90))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.white.opacity(0.20))
                                    .clipShape(Capsule())
                            }

                            Text(habito.titulo)
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(.white)

                            Text(habito.subtitulo)
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.88))

                            // Botón Comenzar
                            HStack(spacing: 8) {
                                Image(systemName: "play.fill")
                                    .font(.system(size: 12))
                                Text("Comenzar ahora")
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                            }
                            .foregroundColor(habito.color)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 10)
                            .background(Color.white)
                            .clipShape(Capsule())
                        }
                        .padding(24)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .shadow(color: habito.color.opacity(0.35), radius: 24, y: 12)
                    .padding(.horizontal, 20)
                }
                .buttonStyle(.plain)
                .transition(.asymmetric(
                    insertion: .scale(scale: 0.92).combined(with: .opacity),
                    removal: .opacity
                ))

                // Chips de info
                HStack(spacing: 12) {
                    infoChip(icono: "clock",               texto: "Diario")
                    infoChip(icono: "flame.fill",          texto: "0 racha")
                    infoChip(icono: "checkmark.seal.fill", texto: "Recomendado")
                }
                .padding(.horizontal, 20)
            }
            .animation(.spring(response: 0.5, dampingFraction: 0.78), value: chipActivo)
        }
    }

    private func infoChip(icono: String, texto: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icono)
                .font(.system(size: 12, weight: .bold))
            Text(texto)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
        }
        .foregroundColor(colorActivo)
        .padding(.horizontal, 14)
        .padding(.vertical, 9)
        .background(colorActivo.opacity(0.10))
        .clipShape(Capsule())
    }
}

// MARK: - Hero Principal

extension HabitosView {

    private var heroCard: some View {
        let habito = habitos[0]
        return Button { abrirHabito(habito) } label: {
            ZStack(alignment: .bottomLeading) {

                Image(habito.imagen)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 300)
                    .frame(maxWidth: .infinity)
                    .clipped()

                LinearGradient(
                    colors: [.clear, .black.opacity(0.72)],
                    startPoint: .center,
                    endPoint: .bottom
                )

                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.white.opacity(0.22))
                            .frame(width: 30, height: 30)
                        Image(systemName: habito.icono)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                    }
                    Text(habito.titulo)
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text(habito.subtitulo)
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.92))
                }
                .padding(24)
            }
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(color: .black.opacity(0.12), radius: 20, y: 10)
            .padding(.horizontal, 20)
            .scaleEffect(habitoPresionado == habito.id ? 0.97 : 1)
            .opacity(animarCards ? 1 : 0)
            .offset(y: animarCards ? 0 : 20)
            .animation(
                .spring(response: 0.7, dampingFraction: 0.82).delay(0.15),
                value: animarCards
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Sección título

extension HabitosView {

    private func seccionTitulo(titulo: String, subtitulo: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(titulo)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.black.opacity(0.88))
                Spacer()
                Text("Ver todo")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(purpura)
            }
            Text(subtitulo)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 22)
    }
}

// MARK: - Cards Horizontales

extension HabitosView {

    private func tarjetaHorizontal(_ habito: HabitoContenido, index: Int) -> some View {
        Button { abrirHabito(habito) } label: {
            HStack(spacing: 16) {
                Image(habito.imagen)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 135, height: 115)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(habito.color)
                            .frame(width: 8, height: 8)
                        Text("Rutina saludable")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(habito.color)
                    }
                    Text(habito.titulo)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.black.opacity(0.88))
                    Text(habito.subtitulo)
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(.gray)
                    Spacer()
                    HStack(spacing: 6) {
                        Image(systemName: habito.icono)
                            .font(.system(size: 12))
                        Text("Bienestar")
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                    }
                    .foregroundColor(.black.opacity(0.65))
                }
                Spacer()
            }
            .padding(14)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .shadow(color: .black.opacity(0.06), radius: 14, y: 6)
            .padding(.horizontal, 20)
            .scaleEffect(habitoPresionado == habito.id ? 0.98 : 1)
            .opacity(animarCards ? 1 : 0)
            .offset(y: animarCards ? 0 : 20)
            .animation(
                .spring(response: 0.8, dampingFraction: 0.82)
                .delay(Double(index) * 0.06),
                value: animarCards
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Abrir Hábito

extension HabitosView {

    private func abrirHabito(_ habito: HabitoContenido) {
        habitoPresionado = habito.id
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            habitoSeleccionado = habito
            irDetalle = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            habitoPresionado = nil
        }
    }
}

// MARK: - Preview

#Preview {
    HabitosView(
        nombreUsuario: "Carla",
        memojiNombre: "perfil"
    )
}
