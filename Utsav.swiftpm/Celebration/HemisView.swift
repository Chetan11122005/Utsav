import SwiftUI

struct FloatingMantra: Identifiable {

    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var scale: CGFloat
    var text: String
    var opacity: Double
}

struct HemisView: View {

    @Environment(\.dismiss) var dismiss

    @State private var wheelRotation: Double = 0.0
    @State private var isSpinning = false
    @State private var mantras: [FloatingMantra] = []
    @State private var spinCount = 0

    let flagColors: [Color] = [.blue, .white, .red, .green, .yellow]
    let mantraSymbols = ["ॐ", "✨", "༄", "🙏"]

    var body: some View {
        ZStack {

            LinearGradient(
                colors: [
                    Color(red: 0.1, green: 0.3, blue: 0.7),
                    Color(red: 0.5, green: 0.8, blue: 0.9)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack {
                HStack(spacing: 5) {
                    ForEach(0..<6) { index in
                        Rectangle()
                            .fill(flagColors[index % flagColors.count])
                            .frame(width: 50, height: 70)
                            .shadow(radius: 2)
                            .rotation3DEffect(
                                .degrees(
                                    isSpinning
                                    ? Double.random(in: -20...20)
                                    : 0
                                ),
                                axis: (x: 1, y: 0, z: 0)
                            )
                            .animation(
                                .easeInOut(duration: 0.5)
                                    .repeatForever(autoreverses: true),
                                value: isSpinning
                            )
                    }
                }
                .padding(.top, 90)
                Spacer()
            }
            .ignoresSafeArea()

            ForEach(mantras) { mantra in
                Text(mantra.text)
                    .font(.system(size: 40))
                    .foregroundStyle(.yellow)
                    .shadow(color: .orange, radius: 10)
                    .position(x: mantra.x, y: mantra.y)
                    .scaleEffect(mantra.scale)
                    .opacity(mantra.opacity)
            }

            VStack {

                Spacer()

                Text(
                    spinCount > 2
                    ? "May peace spread everywhere"
                    : "Swipe horizontally to spin"
                )
                .font(.title2.bold())
                .foregroundStyle(.white)
                .shadow(radius: 5)
                .padding(.bottom, 40)
                .animation(.easeInOut, value: spinCount)

                ZStack {

                    if UIImage(named: "prayer_wheel") != nil {

                        Image("prayer_wheel")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 350)
                            .rotationEffect(.degrees(wheelRotation))

                    } else {

                        ZStack {

                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [.black, .gray, .black],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: 20, height: 400)

                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [.yellow, .orange, .brown, .yellow],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: 160, height: 250)
                                .shadow(
                                    color: .black.opacity(0.5),
                                    radius: 15,
                                    x: 10
                                )
                                .overlay(
                                    VStack(spacing: 40) {
                                        Rectangle()
                                            .fill(.red)
                                            .frame(height: 10)

                                        Text("ॐ मणिपद्मे हूँ")
                                            .font(.title3.bold())
                                            .foregroundStyle(.red)
                                            .rotationEffect(.degrees(90))

                                        Rectangle()
                                            .fill(.red)
                                            .frame(height: 10)
                                    }
                                )
                                .rotation3DEffect(
                                    .degrees(wheelRotation),
                                    axis: (x: 0, y: 1, z: 0)
                                )
                        }
                    }
                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            wheelRotation += value.translation.width / 10
                            triggerHapticClick()
                        }
                        .onEnded { value in

                            let swipeVelocity =
                                value.predictedEndTranslation.width
                                - value.translation.width

                            withAnimation(
                                .easeOut(
                                    duration: Double.random(in: 2.0...4.0)
                                )
                            ) {
                                wheelRotation += swipeVelocity
                            }

                            releaseBlessings()
                        }
                )

                Spacer()
            }

            VStack {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: { }
                }
                Spacer()
            }
        }
    }

    func triggerHapticClick() {
        UIImpactFeedbackGenerator(style: .light)
            .impactOccurred()
    }

    func releaseBlessings() {

        spinCount += 1
        isSpinning = true

        SoundManager.instance.playSound(named: "singing_bowl")
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()

        let spawnCount = Int.random(in: 3...6)

        for _ in 0..<spawnCount {

            let startX = CGFloat.random(
                in: UIScreen.main.bounds.width / 2 - 50
                   ... UIScreen.main.bounds.width / 2 + 50
            )

            let newMantra = FloatingMantra(
                x: startX,
                y: UIScreen.main.bounds.height / 1.5,
                scale: CGFloat.random(in: 0.5...1.5),
                text: mantraSymbols.randomElement()!,
                opacity: 1.0
            )

            mantras.append(newMantra)

            let index = mantras.count - 1

            withAnimation(
                .easeOut(
                    duration: Double.random(in: 3.0...5.0)
                )
            ) {
                mantras[index].y = -100
                mantras[index].opacity = 0.0
                mantras[index].scale = 2.5
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            isSpinning = false
        }
    }
}
