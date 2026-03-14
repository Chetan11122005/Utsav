import SwiftUI

struct HoliCelebrationView: View {

    @Environment(\.dismiss) var dismiss

    @State private var splatters: [Splatter] = []
    @State private var tapCount = 0
    @State private var showClimax = false
    @State private var dripOffset: CGFloat = 0

    let hapticHeavy = UIImpactFeedbackGenerator(style: .heavy)
    let hapticSuccess = UINotificationFeedbackGenerator()

    let holiColors: [Color] = [
        .pink, .cyan, .yellow, .green, .purple, .orange
    ]

    var body: some View {
        GeometryReader { geo in
            ZStack {

                Color(UIColor.white)
                    .ignoresSafeArea()

                ForEach(splatters) { splat in
                    SplatterMark(color: splat.color)
                        .rotationEffect(.degrees(splat.rotation))
                        .scaleEffect(splat.scale)
                        .position(
                            x: splat.x,
                            y: splat.y + dripOffset
                        )
                        .blendMode(.multiply)
                        .transition(
                            .scale(scale: 0.1)
                                .combined(with: .opacity)
                        )
                }

                Color.white.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture(
                        coordinateSpace: .local
                    ) { location in
                        throwBalloon(at: location)
                    }

                if showClimax {

                    HoliConfettiShower()

                    VStack {
                        Spacer()

                        Text("Happy Holi!")
                            .font(
                                .system(
                                    size: 70,
                                    weight: .black,
                                    design: .rounded
                                )
                            )
                            .foregroundStyle(.white)
                            .shadow(color: .pink, radius: 2, x: -4, y: -4)
                            .shadow(color: .cyan, radius: 2, x: 4, y: 4)
                            .shadow(
                                color: .black.opacity(0.5),
                                radius: 10,
                                y: 10
                            )
                            .rotationEffect(.degrees(-5))
                            .transition(
                                .scale(scale: 0.1)
                                    .combined(with: .opacity)
                            )
                            .padding(.bottom, 150)
                    }
                    .zIndex(10)
                }

                VStack {
                    HStack {
                        Spacer()
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .font(.title3.bold())
                                .foregroundStyle(.white.opacity(0.6))
                                .frame(width: 40, height: 40)
                                .background(
                                    .ultraThickMaterial,
                                    in: Circle()
                                )
                                .shadow(radius: 5)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 55)

                    Spacer()

                    if !showClimax {
                        Text("Tap anywhere to throw colors!")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.black.opacity(0.5))
                            .padding(.bottom, 40)
                            .transition(.opacity)
                    }
                }
            }
        }
    }

    func throwBalloon(at location: CGPoint) {

        if showClimax { return }

        hapticHeavy.impactOccurred()

        let newSplat = Splatter(
            x: location.x,
            y: location.y,
            color: holiColors.randomElement()!,
            rotation: Double.random(in: 0...360),
            scale: CGFloat.random(in: 0.8...1.5)
        )

        withAnimation(
            .spring(
                response: 0.4,
                dampingFraction: 0.6
            )
        ) {
            splatters.append(newSplat)
        }

        tapCount += 1

        if tapCount == 10 {
            triggerClimax()
        }
    }

    func triggerClimax() {

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {

            hapticSuccess.notificationOccurred(.success)

            withAnimation(
                .spring(
                    response: 0.6,
                    dampingFraction: 0.6
                )
            ) {
                showClimax = true
            }

            withAnimation(.easeIn(duration: 8.0)) {
                dripOffset = 300
            }
        }
    }
}

struct Splatter: Identifiable {

    let id = UUID()
    let x: CGFloat
    let y: CGFloat
    let color: Color
    let rotation: Double
    let scale: CGFloat
}

struct SplatterMark: View {

    let color: Color

    var body: some View {
        ZStack {

            Circle().frame(width: 80)
            Circle().frame(width: 50).offset(x: 30, y: -20)
            Circle().frame(width: 60).offset(x: -25, y: 30)
            Circle().frame(width: 40).offset(x: -35, y: -15)
            Circle().frame(width: 30).offset(x: 40, y: 35)

            Circle().frame(width: 15).offset(x: -60, y: -50)
            Circle().frame(width: 20).offset(x: 65, y: -10)
            Circle().frame(width: 10).offset(x: 10, y: -70)
            Circle().frame(width: 12).offset(x: -50, y: 60)
            Circle().frame(width: 8).offset(x: 50, y: 70)
        }
        .foregroundStyle(color)
        .blur(radius: 2)
        .opacity(0.85)
    }
}

struct HoliConfettiShower: View {

    @State private var particles: [Confetti] = []

    let timer = Timer.publish(
        every: 0.05,
        on: .main,
        in: .common
    ).autoconnect()

    let colors: [Color] = [
        .pink, .cyan, .yellow, .green, .purple, .orange
    ]

    struct Confetti: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        var color: Color
        var rotation: Double
        var scale: CGFloat
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {

                ForEach(particles) { particle in
                    Rectangle()
                        .fill(particle.color)
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
                        .animation(
                            .linear(duration: 0.5),
                            value: particle.y
                        )
                }
            }
            .onReceive(timer) { _ in

                for _ in 0...2 {

                    let newParticle = Confetti(
                        x: CGFloat.random(in: 0...geo.size.width),
                        y: -50,
                        color: colors.randomElement()!,
                        rotation: Double.random(in: 0...360),
                        scale: CGFloat.random(in: 0.5...1.5)
                    )

                    particles.append(newParticle)
                }

                for i in particles.indices {
                    particles[i].y += CGFloat.random(in: 10...25)
                    particles[i].rotation += CGFloat.random(in: -10...10)
                }

                particles.removeAll {
                    $0.y > geo.size.height + 50
                }
            }
        }
        .ignoresSafeArea()
    }
}
