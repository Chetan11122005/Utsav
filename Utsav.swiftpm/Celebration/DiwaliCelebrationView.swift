import SwiftUI

struct DiwaliCelebrationView: View {

    @Environment(\.dismiss) var dismiss

    let totalDiyas = 5
    @State private var diyasLit: [Bool] = Array(repeating: false, count: 5)
    @State private var showClimax = false

    let lightHaptic = UIImpactFeedbackGenerator(style: .medium)
    let successHaptic = UINotificationFeedbackGenerator()

    var body: some View {
        GeometryReader { geo in
            ZStack {

                let litCount = diyasLit.filter { $0 }.count
                let warmth = Double(litCount) * 0.05

                Color(
                    red: 0.1 + warmth,
                    green: 0.1 + (warmth * 0.5),
                    blue: 0.15
                )
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 1.5), value: litCount)

                if UIImage(named: "rangoli_art") != nil {
                    Image("rangoli_art")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width * 0.7)
                        .grayscale(
                            1.0 - (
                                Double(litCount) /
                                Double(totalDiyas)
                            )
                        )
                        .opacity(
                            0.3 + (
                                0.7 * (
                                    Double(litCount) /
                                    Double(totalDiyas)
                                )
                            )
                        )
                        .shadow(
                            color: .orange.opacity(
                                Double(litCount) * 0.1
                            ),
                            radius: 30
                        )
                        .animation(
                            .easeInOut(duration: 1.0),
                            value: litCount
                        )
                } else {
                    Circle()
                        .fill(.gray.opacity(0.2))
                        .frame(width: geo.size.width * 0.7)
                }

                let radius: CGFloat =
                    geo.size.width * 0.42

                ForEach(0..<totalDiyas, id: \.self) { index in

                    let angle =
                        (Double(index) /
                        Double(totalDiyas)) *
                        2 * .pi

                    let adjustedAngle =
                        angle - (.pi / 2)

                    let xOffset =
                        CGFloat(cos(adjustedAngle)) *
                        radius

                    let yOffset =
                        CGFloat(sin(adjustedAngle)) *
                        radius

                    DiyaView(isLit: $diyasLit[index])
                        .offset(
                            x: xOffset,
                            y: yOffset
                        )
                    
                    .onChange(of: diyasLit[index]) { _, isNowLit in
                        if isNowLit {
                            lightHaptic.impactOccurred()
                            checkCompletion()
                        }
                    }                }

                if showClimax {

                    MarigoldShower()

                    VStack {
                        Spacer()

                        Text("Happy Diwali")
                            .font(
                                .system(
                                    size: 55,
                                    weight: .black,
                                    design: .serif
                                )
                            )
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        .yellow,
                                        .orange,
                                        .red
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(
                                color: .orange.opacity(0.8),
                                radius: 15,
                                y: 5
                            )
                            .shadow(
                                color: .black.opacity(0.5),
                                radius: 5,
                                y: 5
                            )
                            .transition(
                                .scale(scale: 0.8)
                                    .combined(with: .opacity)
                            )
                            .padding(.bottom, 120)
                    }
                    .zIndex(10)
                }

                VStack {
                    HStack {
                        Spacer()
                        Button(action: { dismiss() }) {
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 55)

                    Spacer()

                    if !showClimax {
                        Text("Tap the Diyas to light them")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(
                                .white.opacity(0.7)
                            )
                            .padding(.bottom, 40)
                            .transition(.opacity)
                    }
                }
            }
        }
    }

    func checkCompletion() {
        if diyasLit.allSatisfy({ $0 }) {
            DispatchQueue.main.asyncAfter(
                deadline: .now() + 0.6
            ) {
                successHaptic.notificationOccurred(.success)
                withAnimation(
                    .spring(
                        response: 0.8,
                        dampingFraction: 0.6
                    )
                ) {
                    showClimax = true
                }
            }
        }
    }
}

struct DiyaView: View {

    @Binding var isLit: Bool
    @State private var flamePulse: CGFloat = 1.0

    var body: some View {
        ZStack {

            Circle()
                .fill(
                    isLit
                        ? Color.orange.opacity(0.4)
                        : Color.clear
                )
                .frame(width: 80, height: 80)
                .blur(radius: 20)
                .scaleEffect(flamePulse)

            if UIImage(named: "diya_unlit") != nil {
                Image("diya_unlit")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            } else {
                Capsule()
                    .fill(Color.brown)
                    .frame(width: 40, height: 20)
            }

            if isLit {
                ZStack {

                    Capsule()
                        .fill(Color.orange)
                        .frame(width: 14, height: 28)
                        .blur(radius: 3)

                    Capsule()
                        .fill(Color.yellow)
                        .frame(width: 8, height: 18)
                        .blur(radius: 1)

                    Circle()
                        .fill(Color.white)
                        .frame(width: 4, height: 4)
                        .offset(y: 5)
                }
                .offset(y: -18)
                .scaleEffect(flamePulse)
                .animation(
                    .easeInOut(duration: 0.15)
                        .repeatForever(
                            autoreverses: true
                        ),
                    value: flamePulse
                )
                .onAppear {
                    let randomDuration =
                        Double.random(in: 0.1...0.2)

                    withAnimation(
                        .easeInOut(
                            duration: randomDuration
                        )
                        .repeatForever(
                            autoreverses: true
                        )
                    ) {
                        flamePulse = 1.15
                    }
                }
            }
        }
        .onTapGesture {
            if !isLit {
                withAnimation(.spring()) {
                    isLit = true
                }
            }
        }
    }
}

struct MarigoldShower: View {

    @State private var particles: [Petal] = []

    let timer = Timer.publish(
        every: 0.08,
        on: .main,
        in: .common
    ).autoconnect()

    struct Petal: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        var rotation: Double
        var scale: CGFloat
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {

                ForEach(particles) { particle in

                    if UIImage(named: "marigold_petal") != nil {
                        Image("marigold_petal")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25 * particle.scale)
                            .rotationEffect(
                                .degrees(particle.rotation)
                            )
                            .position(
                                x: particle.x,
                                y: particle.y
                            )
                            .opacity(
                                particle.y >
                                geo.size.height - 100
                                    ? 0
                                    : 1
                            )
                            .animation(
                                .linear(duration: 0.5),
                                value: particle.y
                            )
                    } else {
                        Capsule()
                            .fill(Color.orange)
                            .frame(
                                width: 10 * particle.scale,
                                height: 20 * particle.scale
                            )
                            .rotationEffect(
                                .degrees(particle.rotation)
                            )
                            .position(
                                x: particle.x,
                                y: particle.y
                            )
                    }
                }
            }
            .onReceive(timer) { _ in

                for _ in 0...1 {
                    let newParticle = Petal(
                        x: CGFloat.random(
                            in: 0...geo.size.width
                        ),
                        y: -50,
                        rotation: Double.random(
                            in: 0...360
                        ),
                        scale: CGFloat.random(
                            in: 0.7...1.3
                        )
                    )
                    particles.append(newParticle)
                }

                for i in particles.indices {
                    particles[i].y += CGFloat.random(in: 3...8)
                    particles[i].rotation += CGFloat.random(in: -5...5)
                }

                particles.removeAll {
                    $0.y > geo.size.height + 50
                }
            }
        }
        .ignoresSafeArea()
    }
}
