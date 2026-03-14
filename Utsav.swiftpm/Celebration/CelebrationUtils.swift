import SwiftUI
import AVFoundation

struct ColorSplash: Identifiable {

    let id = UUID()
    let location: CGPoint
    let color: Color
    var scale: CGFloat = 0.5
    var opacity: Double = 1.0
    var rotation: Double = 0.0
}

struct Flower: Identifiable {

    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var scale: CGFloat
    var rotation: Double
}

@MainActor
class SoundManager {

    static let instance = SoundManager()
    var player: AVAudioPlayer?

    private init() {}

    func playSound(named soundName: String) {

        guard
            let url =
                Bundle.main.url(
                    forResource: soundName,
                    withExtension: "mp3"
                ) ??
                Bundle.main.url(
                    forResource: soundName,
                    withExtension: "wav"
                )
        else { return }

        do {
            try AVAudioSession.sharedInstance()
                .setCategory(.playback, mode: .default)

            try AVAudioSession.sharedInstance()
                .setActive(true)

            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()

        } catch {
            print("Error playing sound")
        }
    }
}

struct ParticleSystem: View {

    let color: Color
    @State private var animate = false

    var body: some View {
        ZStack {

            ForEach(0..<25, id: \.self) { _ in
                Circle()
                    .fill(color)
                    .frame(width: 8, height: 8)
                    .offset(
                        x: animate
                            ? CGFloat.random(in: -200...200)
                            : 0,
                        y: animate
                            ? CGFloat.random(in: -400...(-100))
                            : 0
                    )
                    .opacity(animate ? 0 : 1)
                    .animation(
                        .easeOut(duration: 2)
                            .repeatForever(autoreverses: false),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}
