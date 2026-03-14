import SwiftUI

struct CelebrationView: View {

    let festival: Festival
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {

            Color.black.ignoresSafeArea()

            switch festival.name {

            case "Holi":
                HoliCelebrationView()

            case "Diwali":
                DiwaliCelebrationView()

            case "Onam":
                OnamView()

            case "Chhath Puja":
                ChhathView()

            case "Guru Nanak Jayanti":
                GurpurabView()

            case "Buddha Purnima":
                BuddhaView()

            case "Hemis":
                HemisView()

            case "Eid al-Fitr":
                EidCelebrationView()

            case "Christmas":
                ChristmasCelebrationView()

            case "Bihu":
                BihuCelebrationView()

            default:
                Text("Celebration coming soon!")
                    .font(.title)
                    .foregroundStyle(.white)
            }

            VStack {
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 36))
                            .foregroundStyle(.white.opacity(0.6))
                            .padding()
                    }
                }
                Spacer()
            }
        }
    }
}
