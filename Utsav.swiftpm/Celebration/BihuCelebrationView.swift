import SwiftUI

struct BihuCelebrationView: View {

    @Environment(\.dismiss) var dismiss

    @State private var bloomedSpots = [false, false, false, false]
    @State private var showCelebration = false

    let softPopHaptic = UIImpactFeedbackGenerator(style: .soft)
    let successHaptic = UINotificationFeedbackGenerator()

    let spotOffsets: [CGSize] = [
        CGSize(width: -60, height: -140),
        CGSize(width: 80, height: -40),
        CGSize(width: -50, height: 80),
        CGSize(width: 60, height: 200)
    ]

    var body: some View {
        ZStack {

            let bloomCount = bloomedSpots.filter { $0 }.count

            let red = 0.1 + Double(bloomCount) * 0.2
            let green = 0.15 + Double(bloomCount) * 0.15
            let blue = 0.25 - Double(bloomCount) * 0.05

            Color(red: red, green: green, blue: blue)
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 1.5), value: bloomCount)

            ZStack {

                Path { path in
                    path.move(to: CGPoint(x: 100, y: -300))
                    path.addQuadCurve(
                        to: CGPoint(x: -50, y: 400),
                        control: CGPoint(x: -150, y: 50)
                    )
                }
                .stroke(
                    Color.brown.opacity(0.8),
                    style: StrokeStyle(
                        lineWidth: 6,
                        lineCap: .round
                    )
                )
                .offset(
                    x: UIScreen.main.bounds.width / 2,
                    y: UIScreen.main.bounds.height / 2
                )

                ForEach(0..<4) { index in
                    KopouOrchidSpot(
                        isBloomed: $bloomedSpots[index]
                    )
                    .offset(spotOffsets[index])
                    .onChange(of: bloomedSpots[index]) { _, newValue in
                        if newValue {
                            softPopHaptic.impactOccurred(intensity: 1.0)
                            checkCompletion()
                        }
                    }
                }
            }

            if showCelebration {

                PetalBreezeShower()

                VStack {
                    Spacer()

                    Text("Happy Bihu")
                        .font(.system(size: 50, weight: .black, design: .serif))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.pink, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(
                            color: .white.opacity(0.8),
                            radius: 15,
                            y: 0
                        )
                        .padding(.bottom, 120)
                        .transition(
                            .scale(scale: 0.8)
                                .combined(with: .opacity)
                        )
                }
                .zIndex(10)
            }

            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        dismiss()
                        UIImpactFeedbackGenerator(style: .light)
                            .impactOccurred()
                    }) {
                        Image(systemName: "xmark1.circle.fill")
                            .font(.title)
                    }
                    .padding(.trailing, 25)
                    .padding(.top, 60)
                }

                Spacer()

                if !showCelebration {
                    Text("Tap the branches to welcome Spring")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.8))
                        .padding(.bottom, 40)
                        .transition(.opacity)
                }
            }
        }
    }

    func checkCompletion() {
        if bloomedSpots.allSatisfy({ $0 }) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(
                    .spring(
                        response: 1.0,
                        dampingFraction: 0.7
                    )
                ) {
                    showCelebration = true
                    successHaptic.notificationOccurred(.success)
                }
            }
        }
    }
}

struct KopouOrchidSpot: View {

    @Binding var isBloomed: Bool
    @State private var pulseScale: CGFloat = 1.0

    var body: some View {
        ZStack {

            if !isBloomed {

                Circle()
                    .fill(Color.pink.opacity(0.6))
                    .frame(width: 25, height: 25)
                    .blur(radius: 5)
                    .scaleEffect(pulseScale)
                    .onAppear {
                        withAnimation(
                            .easeInOut(duration: 1.2)
                                .repeatForever(autoreverses: true)
                        ) {
                            pulseScale = 1.3
                        }
                    }

                Circle()
                    .fill(Color.white.opacity(0.8))
                    .frame(width: 8, height: 8)
            }

            if isBloomed {

                VStack(spacing: -8) {
                    ForEach(0..<5) { row in
                        HStack(spacing: -4) {
                            ForEach(
                                0..<(3 - (row % 2)),
                                id: \.self
                            ) { _ in
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            gradient: Gradient(
                                                colors: [.pink, .purple]
                                            ),
                                            center: .center,
                                            startRadius: 0,
                                            endRadius: 10
                                        )
                                    )
                                    .frame(
                                        width: 18 - CGFloat(row) * 2,
                                        height: 18 - CGFloat(row) * 2
                                    )
                            }
                        }
                    }
                }
                .shadow(
                    color: .pink.opacity(0.4),
                    radius: 5
                )
                .transition(
                    .scale(scale: 0.2)
                        .combined(with: .opacity)
                )
            }
        }
        .frame(width: 60, height: 80)
        .contentShape(Rectangle())
        .onTapGesture {
            if !isBloomed {
                withAnimation(
                    .spring(
                        response: 0.5,
                        dampingFraction: 0.6
                    )
                ) {
                    isBloomed = true
                }
            }
        }
    }
}

struct PetalBreezeShower: View {

    @State private var petals: [Petal] = []

    let timer = Timer.publish(
        every: 0.08,
        on: .main,
        in: .common
    ).autoconnect()

    struct Petal: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        var scale: CGFloat
        var rotation: Double
        var isPink: Bool
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(petals) { petal in
                    Ellipse()
                        .fill(
                            petal.isPink
                                ? Color.pink.opacity(0.8)
                                : Color.purple.opacity(0.7)
                        )
                        .frame(
                            width: 12 * petal.scale,
                            height: 8 * petal.scale
                        )
                        .rotationEffect(
                            .degrees(petal.rotation)
                        )
                        .position(
                            x: petal.x,
                            y: petal.y
                        )
                        .shadow(
                            color: .pink.opacity(0.3),
                            radius: 2
                        )
                        .opacity(
                            petal.x > geo.size.width - 50
                                ? 0
                                : 1
                        )
                        .animation(
                            .linear(duration: 0.3),
                            value: petal.x
                        )
                }
            }
            .onReceive(timer) { _ in

                let newPetal = Petal(
                    x: -20,
                    y: CGFloat.random(
                        in: 0...(geo.size.height / 2)
                    ),
                    scale: CGFloat.random(in: 0.6...1.4),
                    rotation: Double.random(in: 0...360),
                    isPink: Bool.random()
                )

                petals.append(newPetal)

                for i in petals.indices {
                    petals[i].x += CGFloat.random(in: 10...25)
                    petals[i].y += CGFloat.random(in: 2...8)
                    petals[i].rotation += CGFloat.random(in: 5...15)
                }

                petals.removeAll {
                    $0.x > geo.size.width + 50 ||
                    $0.y > geo.size.height + 50
                }
            }
        }
        .ignoresSafeArea()
    }
}
