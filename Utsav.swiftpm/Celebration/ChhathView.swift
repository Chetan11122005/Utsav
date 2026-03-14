import SwiftUI

struct ChhathView: View {

    @Environment(\.dismiss) var dismiss

    @State private var dragOffset: CGSize = .zero
    @State private var isPouring = false
    @State private var pourProgress: CGFloat = 0.0
    @State private var isCompleted = false

    @State private var sunScale: CGFloat = 1.0
    @State private var sunGlow: CGFloat = 20.0
    @State private var rippleActive = false

    let timer = Timer.publish(
        every: 0.1,
        on: .main,
        in: .common
    ).autoconnect()

    var body: some View {
        ZStack {

            VStack(spacing: 0) {

                LinearGradient(
                    colors: [
                        Color.purple.opacity(0.8),
                        Color.red.opacity(0.8),
                        Color.orange
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .overlay(
                    Color.yellow
                        .opacity(isCompleted ? 0.3 : 0.0)
                        .animation(
                            .easeInOut(duration: 2.0),
                            value: isCompleted
                        )
                )

                LinearGradient(
                    colors: [
                        Color.orange.opacity(0.5),
                        Color.blue.opacity(0.6),
                        Color.blue.opacity(0.8)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .ignoresSafeArea()

            ZStack {

                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.yellow, .orange],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 120, height: 120)
                    .shadow(
                        color: .orange,
                        radius: sunGlow
                    )
                    .scaleEffect(sunScale)

                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                .yellow.opacity(0.6),
                                .clear
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 80, height: 150)
                    .blur(radius: 10)
                    .offset(y: 130)
                    .opacity(isCompleted ? 1.0 : 0.5)
            }
            .offset(y: -50)

            VStack {

                VStack(spacing: 15) {

                    Text(
                        isCompleted
                            ? "May Surya Dev bless you!"
                            : "Drag Soop up & hold to offer Arghya"
                    )
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .shadow(radius: 5)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                    if !isCompleted {

                        GeometryReader { geo in
                            ZStack(alignment: .leading) {

                                Capsule()
                                    .fill(Color.white.opacity(0.3))
                                    .frame(height: 10)

                                Capsule()
                                    .fill(Color.yellow)
                                    .frame(
                                        width: geo.size.width * pourProgress,
                                        height: 10
                                    )
                                    .animation(
                                        .linear(duration: 0.1),
                                        value: pourProgress
                                    )
                            }
                        }
                        .frame(width: 200, height: 10)
                        .opacity(isPouring ? 1.0 : 0.0)
                    }
                }
                .padding(.top, 50)

                Spacer()

                ZStack {

                    if isPouring || isCompleted {

                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(0.9),
                                        .white.opacity(0.1)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 8, height: 300)
                            .offset(x: -80, y: 150)
                            .transition(.opacity)
                    }

                    if (isPouring || isCompleted) && rippleActive {

                        Ellipse()
                            .stroke(
                                Color.white.opacity(0.5),
                                lineWidth: 2
                            )
                            .frame(width: 100, height: 30)
                            .offset(x: -80, y: 300)
                            .scaleEffect(
                                rippleActive ? 1.5 : 0.5
                            )
                            .opacity(
                                rippleActive ? 0 : 1
                            )
                            .animation(
                                .easeOut(duration: 1.0)
                                    .repeatForever(
                                        autoreverses: false
                                    ),
                                value: rippleActive
                            )
                            .onAppear {
                                rippleActive = true
                            }
                    }

                    if UIImage(named: "soop") != nil {

                        Image("soop")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 280)

                    } else {

                        ZStack {

                            Path { path in
                                path.move(
                                    to: CGPoint(x: 0, y: 50)
                                )
                                path.addLine(
                                    to: CGPoint(x: 250, y: 50)
                                )
                                path.addLine(
                                    to: CGPoint(x: 200, y: 150)
                                )
                                path.addLine(
                                    to: CGPoint(x: 50, y: 150)
                                )
                                path.closeSubpath()
                            }
                            .fill(Color.brown.opacity(0.9))
                            .frame(width: 250, height: 150)

                            Circle()
                                .fill(.red)
                                .frame(width: 40)
                                .offset(x: -50, y: -20)

                            Circle()
                                .fill(.yellow)
                                .frame(width: 40)
                                .offset(x: 10, y: -10)

                            Circle()
                                .fill(.green)
                                .frame(width: 30)
                                .offset(x: 50, y: -20)
                        }
                    }
                }
                .rotationEffect(
                    .degrees(
                        isCompleted
                            ? -25
                            : Double(
                                max(
                                    -30,
                                    dragOffset.height / 6
                                )
                            )
                    )
                )
                .offset(
                    x: dragOffset.width,
                    y: isCompleted
                        ? -150
                        : dragOffset.height
                )
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            guard !isCompleted else { return }

                            let cappedY = max(
                                -180,
                                value.translation.height
                            )
                            let cappedX =
                                value.translation.width / 4

                            dragOffset = CGSize(
                                width: cappedX,
                                height: cappedY
                            )

                            if cappedY <= -150 {
                                withAnimation {
                                    isPouring = true
                                }
                            } else {
                                withAnimation {
                                    isPouring = false
                                }
                            }
                        }
                        .onEnded { _ in
                            guard !isCompleted else { return }

                            isPouring = false

                            withAnimation(
                                .spring(
                                    response: 0.5,
                                    dampingFraction: 0.6
                                )
                            ) {
                                dragOffset = .zero
                            }
                        }
                )
                .padding(.bottom, 60)
            }

            VStack {
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 36))
                            .foregroundStyle(
                                .white.opacity(0.8)
                            )
                            .padding()
                    }
                }
                Spacer()
            }
        }
        .onReceive(timer) { _ in

            if isPouring && !isCompleted {

                pourProgress += 0.05

                UIImpactFeedbackGenerator(style: .soft)
                    .impactOccurred()

                if pourProgress >= 1.0 {
                    triggerBlessing()
                }

            } else if !isPouring && !isCompleted && pourProgress > 0 {

                pourProgress = max(
                    0,
                    pourProgress - 0.1
                )
            }
        }
    }

    func triggerBlessing() {

        isCompleted = true
        isPouring = false

        UIImpactFeedbackGenerator(style: .heavy)
            .impactOccurred()

        SoundManager.instance.playSound(
            named: "splash_sound"
        )

        withAnimation(.easeIn(duration: 2.0)) {
            sunScale = 1.5
            sunGlow = 60.0
        }
    }
}
