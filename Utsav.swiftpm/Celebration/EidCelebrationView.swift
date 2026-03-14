import SwiftUI
import AVFoundation

struct EidCelebrationView: View {

    @Environment(\.dismiss) var dismiss

    @State private var lanternsLit = [false, false, false]
    @State private var showCelebration = false

    let lightHaptic = UIImpactFeedbackGenerator(style: .light)
    let heavyHaptic = UIImpactFeedbackGenerator(style: .heavy)
    let successHaptic = UINotificationFeedbackGenerator()

    let stringLengths: [CGFloat] = [120, 200, 150]

    var body: some View {
        ZStack {

            let litCount = lanternsLit.filter { $0 }.count
            let skyBrightness = 0.05 + Double(litCount) * 0.05

            Color(
                red: skyBrightness,
                green: skyBrightness * 0.8,
                blue: 0.15 + skyBrightness * 0.5
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 1.0), value: litCount)

            HStack(alignment: .top, spacing: 40) {
                ForEach(0..<3, id: \.self) { index in
                    FanoosLantern(
                        isLit: $lanternsLit[index],
                        stringLength: stringLengths[index]
                    )
                    
                    .onChange(of: lanternsLit[index]) { _, lit in
                        if lit {
                            lightHaptic.impactOccurred()
                            checkCompletion()
                        }
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.top, -50)

            if showCelebration {

                ParticleShower()

                VStack {
                    Spacer()

                    Text("Eid Mubarak")
                        .font(.system(size: 50, weight: .black, design: .serif))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.yellow, .orange, .yellow],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: .orange.opacity(0.8), radius: 20, y: 5)
                        .padding(.bottom, 150)
                        .transition(
                            .scale(scale: 0.5)
                                .combined(with: .opacity)
                        )
                }
                .zIndex(10)
            }

            VStack {
                HStack {
                    Spacer()

                    Button {
                        dismiss()
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundStyle(.white.opacity(0.6))
                    }
                    .padding(.trailing, 25)
                    .padding(.top, 60)
                }

                Spacer()

                if !showCelebration {
                    Text("Tap the lanterns to light them")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.6))
                        .padding(.bottom, 40)
                        .transition(.opacity)
                }
            }
        }
    }

    func checkCompletion() {
        if lanternsLit.allSatisfy({ $0 }) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(
                    .spring(response: 0.8, dampingFraction: 0.6)
                ) {
                    showCelebration = true
                    successHaptic.notificationOccurred(.success)
                }
            }
        }
    }
}

struct FanoosLantern: View {

    @Binding var isLit: Bool
    let stringLength: CGFloat

    @State private var swingAngle: Double = 0
    @State private var tapScale: CGFloat = 1.0

    var body: some View {
        VStack(spacing: 0) {

            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [.gray.opacity(0.5), .gray],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 2, height: stringLength)

            ZStack {
                VStack(spacing: 0) {

                    Circle()
                        .strokeBorder(.brown, lineWidth: 3)
                        .frame(width: 12, height: 12)

                    Path { path in
                        path.move(to: CGPoint(x: 15, y: 0))
                        path.addLine(to: CGPoint(x: 35, y: 0))
                        path.addLine(to: CGPoint(x: 50, y: 20))
                        path.addLine(to: CGPoint(x: 0, y: 20))
                        path.closeSubpath()
                    }
                    .fill(Color(UIColor.systemBrown))
                    .frame(width: 50, height: 20)

                    ZStack {

                        RoundedRectangle(cornerRadius: 15)
                            .fill(
                                isLit
                                    ? Color.yellow.opacity(0.3)
                                    : Color.white.opacity(0.05)
                            )
                            .frame(width: 60, height: 80)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.brown, lineWidth: 4)
                            )

                        HStack(spacing: 15) {
                            Rectangle()
                                .fill(Color.brown)
                                .frame(width: 2, height: 80)

                            Rectangle()
                                .fill(Color.brown)
                                .frame(width: 2, height: 80)
                        }

                        if isLit {
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [.yellow, .orange],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(width: 14, height: 24)
                                .blur(radius: 2)
                                .shadow(color: .white, radius: 5)
                                .opacity(swingAngle > 0 ? 0.8 : 1.0)
                                .animation(
                                    .easeInOut(duration: 0.1)
                                        .repeatForever(),
                                    value: swingAngle
                                )
                        }
                    }

                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color(UIColor.systemBrown))
                        .frame(width: 40, height: 12)
                }
            }
            .shadow(
                color: isLit ? .yellow.opacity(0.8) : .clear,
                radius: isLit ? 40 : 0,
                x: 0,
                y: 10
            )
            .shadow(
                color: isLit ? .orange.opacity(0.5) : .clear,
                radius: isLit ? 80 : 0,
                x: 0,
                y: 20
            )
            .scaleEffect(tapScale)
            .onTapGesture {

                guard !isLit else { return }

                withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                    tapScale = 1.1
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                        tapScale = 1.0
                        isLit = true
                    }
                }

                withAnimation(.spring(response: 0.5, dampingFraction: 0.3)) {
                    swingAngle =
                        Double.random(in: 10...15) *
                        (Bool.random() ? 1 : -1)
                }
            }
        }
        .rotationEffect(.degrees(swingAngle), anchor: .top)
        .onAppear {
            let randomDuration = Double.random(in: 2.5...3.5)
            let randomAngle = Double.random(in: -3...3)

            withAnimation(
                .easeInOut(duration: randomDuration)
                    .repeatForever(autoreverses: true)
            ) {
                swingAngle = randomAngle
            }
        }
    }
}

struct ParticleShower: View {

    @State private var particles: [Particle] = []

    let timer = Timer.publish(
        every: 0.1,
        on: .main,
        in: .common
    ).autoconnect()

    struct Particle: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        var scale: CGFloat
        var isMoon: Bool
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {

                ForEach(particles) { particle in
                    Image(
                        systemName:
                            particle.isMoon
                            ? "moon.stars.fill"
                            : "star.fill"
                    )
                    .foregroundStyle(.yellow)
                    .font(.system(size: 20 * particle.scale))
                    .position(x: particle.x, y: particle.y)
                    .shadow(color: .orange.opacity(0.8), radius: 5)
                    .opacity(
                        particle.y > geo.size.height - 100
                            ? 0
                            : 1
                    )
                    .animation(
                        .linear(duration: 0.5),
                        value: particle.y
                    )
                }
            }
            .onReceive(timer) { _ in

                let newParticle = Particle(
                    x: CGFloat.random(in: 0...geo.size.width),
                    y: -50,
                    scale: CGFloat.random(in: 0.5...1.5),
                    isMoon: Bool.random()
                )

                particles.append(newParticle)

                for i in particles.indices {
                    particles[i].y += CGFloat.random(in: 5...15)
                }

                particles.removeAll {
                    $0.y > geo.size.height + 50
                }
            }
        }
        .ignoresSafeArea()
    }
}
