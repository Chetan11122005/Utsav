import SwiftUI

struct ChristmasCelebrationView: View {

    @Environment(\.dismiss) var dismiss

    @State private var ornaments: [Ornament] = []
    @State private var isStarPlaced = false
    @State private var starScale: CGFloat = 1.0

    let tapHaptic = UIImpactFeedbackGenerator(style: .medium)
    let magicHaptic = UINotificationFeedbackGenerator()

    @State private var lightPositions: [CGPoint] =
        (0..<30).map { _ in
            CGPoint(
                x: CGFloat.random(in: 40...320),
                y: CGFloat.random(in: 100...420)
            )
        }

    var body: some View {
        ZStack {

            LinearGradient(
                colors: isStarPlaced
                    ? [
                        Color(red: 0.1, green: 0.1, blue: 0.3),
                        .black
                    ]
                    : [
                        .black,
                        Color(red: 0.05, green: 0.05, blue: 0.1)
                    ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .animation(
                .easeInOut(duration: 2.0),
                value: isStarPlaced
            )

            if isStarPlaced {
                SnowParticleShower()
            }

            VStack(spacing: 0) {

                Spacer()

                ZStack {

                    Image("christmas_tree")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 360, height: 500)
                        .shadow(
                            color: .black.opacity(0.4),
                            radius: 15,
                            y: 10
                        )

                    if isStarPlaced {

                        ForEach(
                            0..<lightPositions.count,
                            id: \.self
                        ) { index in
                            Circle()
                                .fill(
                                    index % 2 == 0
                                        ? Color.yellow
                                        : Color.white
                                )
                                .frame(width: 6, height: 6)
                                .position(lightPositions[index])
                                .shadow(color: .yellow, radius: 4)
                                .opacity(
                                    Double.random(in: 0.4...1.0)
                                )
                                .animation(
                                    .easeInOut(
                                        duration: Double.random(
                                            in: 0.5...1.5
                                        )
                                    )
                                    .repeatForever(),
                                    value: isStarPlaced
                                )
                        }
                    }

                    ForEach(ornaments) { ornament in
                        Image(systemName: ornament.icon)
                            .font(.system(size: 24))
                            .foregroundStyle(ornament.color)
                            .position(ornament.position)
                            .shadow(
                                color: .black.opacity(0.3),
                                radius: 2,
                                y: 2
                            )
                            .transition(
                                .scale.combined(with: .opacity)
                            )
                    }

                    if ornaments.count < 7 {

                        Color.white.opacity(0.001)
                            .frame(width: 360, height: 800)
                            .onTapGesture(
                                coordinateSpace: .local
                            ) { location in
                                addOrnament(at: location)
                            }
                    }

                    ZStack {

                        if ornaments.count >= 7 &&
                            !isStarPlaced {

                            Image(systemName: "star")
                                .font(
                                    .system(
                                        size: 40,
                                        weight: .light
                                    )
                                )
                                .foregroundStyle(
                                    .yellow.opacity(0.8)
                                )
                                .scaleEffect(starScale)
                                .animation(
                                    .easeInOut(duration: 0.8)
                                        .repeatForever(
                                            autoreverses: true
                                        ),
                                    value: starScale
                                )
                                .onAppear {
                                    starScale = 1.2
                                }
                                .onTapGesture {
                                    placeStar()
                                }

                        } else if isStarPlaced {

                            Image(systemName: "star.fill")
                                .font(
                                    .system(
                                        size: 50,
                                        weight: .bold
                                    )
                                )
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            .yellow,
                                            .white,
                                            .yellow
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .shadow(color: .yellow, radius: 30)
                                .shadow(color: .orange, radius: 60)
                                .transition(
                                    .scale.combined(with: .opacity)
                                )
                        }
                    }
                    .position(x: 180, y: 10)
                    .zIndex(10)
                }
                .frame(width: 360, height: 500)
                .padding(.bottom, 50)
            }

            if isStarPlaced {

                VStack {

                    Text("Merry Christmas")
                        .font(
                            .system(
                                size: 44,
                                weight: .black,
                                design: .serif
                            )
                        )
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    .red,
                                    .white,
                                    .red
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(
                            color: .red.opacity(0.8),
                            radius: 20,
                            y: 5
                        )
                        .padding(.top, 100)
                        .transition(
                            .move(edge: .top)
                                .combined(with: .opacity)
                        )

                    Spacer()
                }
                .zIndex(10)
            }

            VStack {

                HStack {
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 55)

                Spacer()

                if ornaments.count < 7 {

                    Text("Tap the tree to decorate it!")
                        .font(.headline)
                        .foregroundStyle(
                            .white.opacity(0.6)
                        )
                        .padding(.bottom, 40)
                        .transition(.opacity)

                } else if !isStarPlaced {

                    Text("Place the star on top!")
                        .font(.headline)
                        .foregroundStyle(.yellow)
                        .shadow(
                            color: .yellow.opacity(0.5),
                            radius: 5
                        )
                        .padding(.bottom, 40)
                        .transition(.opacity)
                }
            }
        }
    }

    func addOrnament(at location: CGPoint) {

        tapHaptic.impactOccurred()

        let availableOrnaments: [(String, Color)] = [
            ("circle.fill", .red),
            ("circle.fill", .blue),
            ("bell.fill", .yellow),
            ("candybar.fill", .mint),
            ("gift.fill", .purple)
        ]

        let randomChoice =
            availableOrnaments.randomElement()!

        let newOrnament = Ornament(
            position: location,
            icon: randomChoice.0,
            color: randomChoice.1
        )

        withAnimation(
            .spring(
                response: 0.4,
                dampingFraction: 0.6
            )
        ) {
            ornaments.append(newOrnament)
        }
    }

    func placeStar() {

        magicHaptic.notificationOccurred(.success)

        withAnimation(
            .spring(
                response: 0.8,
                dampingFraction: 0.6
            )
        ) {
            isStarPlaced = true
        }
    }
}

struct Ornament: Identifiable {

    let id = UUID()
    let position: CGPoint
    let icon: String
    let color: Color
}

struct SnowParticleShower: View {

    @State private var snowflakes: [Snowflake] = []

    let timer = Timer.publish(
        every: 0.05,
        on: .main,
        in: .common
    ).autoconnect()

    struct Snowflake: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        var scale: CGFloat
        var speed: CGFloat
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {

                ForEach(snowflakes) { flake in
                    Circle()
                        .fill(.white)
                        .frame(
                            width: 6 * flake.scale,
                            height: 6 * flake.scale
                        )
                        .position(
                            x: flake.x,
                            y: flake.y
                        )
                        .opacity(
                            flake.y >
                                geo.size.height - 50
                                ? 0
                                : 0.8
                        )
                }
            }
            .onReceive(timer) { _ in

                let newFlake = Snowflake(
                    x: CGFloat.random(
                        in: 0...geo.size.width
                    ),
                    y: -10,
                    scale: CGFloat.random(
                        in: 0.3...1.2
                    ),
                    speed: CGFloat.random(in: 2...6)
                )

                snowflakes.append(newFlake)

                for i in snowflakes.indices {
                    snowflakes[i].y += snowflakes[i].speed
                    snowflakes[i].x += CGFloat.random(
                        in: -0.5...0.5
                    )
                }

                snowflakes.removeAll {
                    $0.y > geo.size.height + 20
                }
            }
        }
        .ignoresSafeArea()
    }
}
