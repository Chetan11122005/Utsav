import SwiftUI

struct PookkalamRing {

    let emoji: String
    let count: Int
    let radius: CGFloat
    let scale: CGFloat
}

struct OnamView: View {

    @Environment(\.dismiss) var dismiss

    @State private var completedLayers = 0
    @State private var dragOffset: CGSize = .zero
    @State private var isLampLit = false
    @State private var globalRotation: Double = 0.0

    let rings: [PookkalamRing] = [
        PookkalamRing(emoji: "🏵️", count: 8, radius: 45, scale: 1.0),
        PookkalamRing(emoji: "🌸", count: 14, radius: 85, scale: 1.2),
        PookkalamRing(emoji: "🌼", count: 20, radius: 130, scale: 1.4),
        PookkalamRing(emoji: "🌺", count: 28, radius: 180, scale: 1.5)
    ]

    var body: some View {
        ZStack {

            RadialGradient(
                colors: [
                    Color(red: 1.0, green: 0.98, blue: 0.9),
                    Color(red: 0.95, green: 0.85, blue: 0.6)
                ],
                center: .center,
                startRadius: 10,
                endRadius: 600
            )
            .ignoresSafeArea()

            VStack {

                Text(
                    completedLayers == rings.count
                    ? "Happy Onam!"
                    : "Drag the flower to the center"
                )
                .font(.title2.bold())
                .foregroundStyle(Color.orange.opacity(0.8))
                .padding(.top, 50)

                Spacer()

                ZStack {

                    Circle()
                        .strokeBorder(
                            Color.orange.opacity(0.2),
                            style: StrokeStyle(
                                lineWidth: 2,
                                dash: [5]
                            )
                        )
                        .frame(width: 100, height: 100)
                        .scaleEffect(
                            completedLayers == rings.count ? 0 : 1
                        )
                        .animation(
                            .easeOut,
                            value: completedLayers
                        )

                    ForEach(
                        0..<completedLayers,
                        id: \.self
                    ) { layerIndex in

                        let ring = rings[layerIndex]

                        ForEach(
                            0..<ring.count,
                            id: \.self
                        ) { petalIndex in

                            let angle =
                                (Double(petalIndex) /
                                 Double(ring.count)) * 360.0

                            Text(ring.emoji)
                                .font(.system(size: 30))
                                .scaleEffect(ring.scale)
                                .offset(y: -ring.radius)
                                .rotationEffect(
                                    .degrees(angle)
                                )
                                .transition(
                                    .scale
                                        .combined(
                                            with: .opacity
                                        )
                                )
                        }
                    }

                    if completedLayers == rings.count {

                        ZStack {

                            if UIImage(named: "kerala_lamp") != nil {

                                Image("kerala_lamp")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 120)
                                    .shadow(
                                        color: .black.opacity(0.3),
                                        radius: 10,
                                        y: 5
                                    )

                            } else {

                                Image(systemName: "building.columns.fill")
                                    .font(.system(size: 80))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [
                                                .yellow,
                                                .brown
                                            ],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                            }

                            Image(systemName: "flame.fill")
                                .font(.system(size: 30))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            .red,
                                            .orange,
                                            .yellow
                                        ],
                                        startPoint: .bottom,
                                        endPoint: .top
                                    )
                                )
                                .offset(y: -55)
                                .scaleEffect(
                                    isLampLit ? 1.0 : 0.0,
                                    anchor: .bottom
                                )
                                .shadow(
                                    color: .orange,
                                    radius: isLampLit ? 20 : 0
                                )
                                .animation(
                                    .spring(
                                        response: 0.5,
                                        dampingFraction: 0.5
                                    )
                                    .delay(0.5),
                                    value: isLampLit
                                )
                        }
                        .transition(
                            .scale
                                .combined(with: .opacity)
                        )
                    }
                }
                .rotationEffect(
                    .degrees(globalRotation)
                )

                Spacer()

                ZStack {

                    Color.clear
                        .frame(height: 120)

                    if completedLayers < rings.count {

                        let currentRing =
                            rings[completedLayers]

                        ZStack {

                            Circle()
                                .fill(.white.opacity(0.5))
                                .frame(
                                    width: 80,
                                    height: 80
                                )
                                .shadow(radius: 5)

                            Text(currentRing.emoji)
                                .font(.system(size: 50))
                        }
                        .offset(dragOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    dragOffset =
                                        value.translation
                                }
                                .onEnded { value in
                                    if value.translation.height < -150 {
                                        buildNextLayer()
                                    } else {
                                        withAnimation(
                                            .spring(
                                                response: 0.3,
                                                dampingFraction: 0.6
                                            )
                                        ) {
                                            dragOffset = .zero
                                        }
                                    }
                                }
                        )
                    }
                }
                .padding(.bottom, 50)
            }

            VStack {
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 36))
                            .foregroundStyle(
                                Color.white.opacity(0.6)
                            )
                            .padding()
                    }
                }
                Spacer()
            }
        }
    }

    func buildNextLayer() {

        UIImpactFeedbackGenerator(style: .medium)
            .impactOccurred()

        SoundManager.instance.playSound(
            named: "sparkle_sound"
        )

        dragOffset = .zero

        withAnimation(
            .spring(
                response: 0.6,
                dampingFraction: 0.7
            )
        ) {
            completedLayers += 1
        }

        if completedLayers == rings.count {
            triggerGrandFinale()
        }
    }

    func triggerGrandFinale() {

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.3
        ) {

            UIImpactFeedbackGenerator(style: .heavy)
                .impactOccurred()

            withAnimation {
                isLampLit = true
            }

            withAnimation(
                .linear(duration: 30)
                    .repeatForever(
                        autoreverses: false
                    )
            ) {
                globalRotation = 360
            }
        }
    }
}
