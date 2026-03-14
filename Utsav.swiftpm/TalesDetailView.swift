import SwiftUI
import AVFoundation

struct TaleDetailView: View {

    let tale: Tale
    @ObservedObject var data: TalesData

    @State private var synthesizer = AVSpeechSynthesizer()
    @State private var isSpeaking = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {

                ZStack(alignment: .bottomLeading) {

                    Rectangle()
                        .fill(tale.color.gradient)
                        .frame(height: 280)

                    VStack(alignment: .leading) {

                        Image(systemName: tale.image)
                            .font(.system(size: 70))
                            .foregroundStyle(.white)
                            .shadow(radius: 10)
                            .padding(.bottom, 5)

                        Text(tale.festivalName)
                            .font(.system(size: 42, weight: .black))
                            .foregroundStyle(.white)
                            .shadow(radius: 10)
                    }
                    .padding(30)
                }

                VStack(alignment: .leading, spacing: 30) {

                    HStack {

                        VStack(alignment: .leading) {

                            Text("The Legend")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                                .textCase(.uppercase)

                            Text("Listen to the story")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Button(action: toggleSpeech) {
                            HStack {

                                Image(
                                    systemName: isSpeaking
                                        ? "stop.circle.fill"
                                        : "play.circle.fill"
                                )
                                .font(.title)

                                Text(isSpeaking ? "Stop" : "Listen")
                                    .font(.headline)
                            }
                            .foregroundStyle(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(tale.color)
                            .clipShape(Capsule())
                        }
                    }

                    Text(tale.story)
                        .font(.system(size: 21, design: .serif))
                        .lineSpacing(10)
                        .foregroundStyle(.primary.opacity(0.9))

                    Divider()

                    VStack(alignment: .leading, spacing: 15) {

                        Text("Decode the Traditions")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                            .textCase(.uppercase)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(tale.rituals, id: \.self) { ritual in
                                    FlipCard(
                                        content: ritual,
                                        color: tale.color
                                    )
                                }
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 5)
                        }
                    }

                    HStack(alignment: .top) {

                        Image(systemName: "lightbulb.fill")
                            .font(.title2)
                            .foregroundStyle(.yellow)
                            .padding(.top, 2)

                        VStack(alignment: .leading, spacing: 5) {

                            Text("Did you know?")
                                .font(.headline)

                            Text(tale.funFact)
                                .font(.subheadline)
                                .italic()
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        Color(uiColor: .secondarySystemBackground)
                    )
                    .cornerRadius(15)
                }
                .padding(25)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .onDisappear {
            if synthesizer.isSpeaking {
                synthesizer.stopSpeaking(at: .immediate)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 10) {

                    Button(action: {
                        withAnimation(
                            .spring(
                                response: 0.4,
                                dampingFraction: 0.6
                            )
                        ) {
                            data.toggleLike(for: tale)
                        }
                        UIImpactFeedbackGenerator(
                            style: .medium
                        ).impactOccurred()
                    }) {
                        Image(
                            systemName: tale.isLiked
                                ? "heart.fill"
                                : "heart"
                        )
                        .font(.title3)
                        .foregroundStyle(
                            tale.isLiked
                                ? .red
                                : .primary
                        )
                    }

                    ShareLink(
                        item: "\(tale.festivalName): \(tale.story)"
                    ) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title3)
                            .foregroundStyle(.primary)
                    }
                }
            }
        }
    }

    func toggleSpeech() {

        if isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
            isSpeaking = false
        } else {
            let utterance = AVSpeechUtterance(string: tale.story)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-IN")
            utterance.rate = 0.5
            synthesizer.speak(utterance)
            isSpeaking = true
        }
    }
}

struct FlipCard: View {

    let content: String
    let color: Color

    @State private var isFlipped = false
    @State private var rotation: Double = 0

    var body: some View {
        ZStack {

            if rotation < 90 {

                VStack {

                    Image(systemName: "sparkles")
                        .font(.largeTitle)
                        .foregroundStyle(.white)

                    Text("Tap to Reveal")
                        .font(.caption.bold())
                        .foregroundStyle(.white.opacity(0.8))
                }
                .frame(width: 140, height: 180)
                .background(color.gradient)
                .cornerRadius(20)

            } else {

                VStack {

                    Text(content)
                        .font(.system(size: 16, weight: .medium))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(color)
                        .padding()
                }
                .frame(width: 140, height: 180)
                .background(Color.white)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(color, lineWidth: 2)
                )
                .rotation3DEffect(
                    .degrees(180),
                    axis: (x: 0, y: 1, z: 0)
                )
            }
        }
        .rotation3DEffect(
            .degrees(rotation),
            axis: (x: 0, y: 1, z: 0)
        )
        .onTapGesture {
            withAnimation(
                .spring(
                    response: 0.6,
                    dampingFraction: 0.8
                )
            ) {
                rotation = isFlipped ? 0 : 180
                isFlipped.toggle()
            }
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
        .shadow(
            color: .black.opacity(0.1),
            radius: 5,
            x: 0,
            y: 5
        )
    }
}
