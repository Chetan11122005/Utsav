import SwiftUI

struct GurpurabPetal: Identifiable {

    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var scale: CGFloat
    var rotation: Double
}

struct GurpurabView: View {

    @Environment(\.dismiss) var dismiss

    @State private var flowerOffset: CGSize = .zero
    @State private var isOffered = false
    @State private var glowRadius: CGFloat = 20.0
    @State private var petals: [GurpurabPetal] = []

    let petalTimer = Timer.publish(
        every: 0.2,
        on: .main,
        in: .common
    ).autoconnect()

    var body: some View {
        ZStack {

            LinearGradient(
                colors: [
                    Color.orange.opacity(0.6),
                    Color.blue.opacity(0.3)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            Circle()
                .fill(
                    Color.yellow.opacity(
                        isOffered ? 0.6 : 0.3
                    )
                )
                .frame(width: 300, height: 300)
                .blur(radius: glowRadius)
                .animation(
                    .easeInOut(duration: 2.0)
                        .repeatForever(autoreverses: true),
                    value: glowRadius
                )
                .onAppear {
                    glowRadius = 40.0
                }

            ForEach(petals) { petal in
                Text("🌸")
                    .font(.title2)
                    .position(x: petal.x, y: petal.y)
                    .rotationEffect(.degrees(petal.rotation))
                    .scaleEffect(petal.scale)
            }

            VStack {

                Text(
                    isOffered
                    ? "Happy Guru Nanak Jayanti"
                    : "Offer a flower"
                )
                .font(.title2.bold())
                .foregroundStyle(.white)
                .shadow(radius: 5)
                .padding(.top, 50)
                .opacity(isOffered ? 1 : 0.8)

                if isOffered {
                    Text("Waheguru")
                        .font(.title3)
                        .foregroundStyle(.yellow)
                        .padding(.top, 5)
                        .transition(.opacity)
                }

                Spacer()

                ZStack {

                    if UIImage(named: "guru_nanak") != nil {

                        Image("guru_nanak")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .shadow(
                                color: .orange.opacity(0.5),
                                radius: 15
                            )

                    } else {

                        Text("ੴ")
                            .font(.system(size: 150))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.yellow, .orange],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .shadow(color: .orange, radius: 20)
                    }
                }
                .offset(y: -30)

                Spacer()

                ZStack {

                    Color.clear.frame(height: 100)

                    if !isOffered {
                        Text("🌸")
                            .font(.system(size: 80))
                            .shadow(radius: 5)
                            .offset(flowerOffset)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        flowerOffset = value.translation
                                    }
                                    .onEnded { value in
                                        if value.translation.height < -150 {
                                            completeOffering()
                                        } else {
                                            withAnimation(
                                                .spring(
                                                    response: 0.3,
                                                    dampingFraction: 0.6
                                                )
                                            ) {
                                                flowerOffset = .zero
                                            }
                                        }
                                    }
                            )
                    }
                }
                .padding(.bottom, 60)
            }

            VStack {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 36))
                            .foregroundStyle(.white.opacity(0.8))
                            .padding()
                    }
                }
                Spacer()
            }
        }
        .onReceive(petalTimer) { _ in
            if isOffered {
                spawnPetal()
            }
        }
    }

    func completeOffering() {

        UIImpactFeedbackGenerator(style: .heavy)
            .impactOccurred()

        SoundManager.instance.playSound(
            named: "sparkle_sound"
        )

        withAnimation(.spring()) {
            isOffered = true
        }

        withAnimation(.easeOut(duration: 2.0)) {
            glowRadius = 80.0
        }
    }

    func spawnPetal() {

        let startX = CGFloat.random(
            in: 0...UIScreen.main.bounds.width
        )

        let newPetal = GurpurabPetal(
            x: startX,
            y: -50,
            scale: CGFloat.random(in: 0.6...1.2),
            rotation: Double.random(in: 0...360)
        )

        withAnimation {
            petals.append(newPetal)
        }

        let index = petals.count - 1

        if index >= 0 {
            withAnimation(.linear(duration: 4)) {
                petals[index].y =
                    UIScreen.main.bounds.height + 100
                petals[index].rotation += 180
            }
        }

        if petals.count > 40 {
            petals.removeFirst()
        }
    }
}
