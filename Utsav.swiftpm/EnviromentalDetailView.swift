import SwiftUI

struct EnvironmentDetailView: View {

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {

                ZStack(alignment: .bottomLeading) {

                    LinearGradient(
                        colors: [
                            Color.green,
                            Color.teal.opacity(0.6),
                            .black
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 300)

                    VStack(alignment: .leading, spacing: 8) {

                        Text("Green Diwali")
                            .font(.system(size: 42, weight: .black))
                            .foregroundStyle(.white)

                        Text("Celebrating with light, protecting our air.")
                            .font(.title3)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    .padding(30)
                }

                VStack(alignment: .leading, spacing: 25) {

                    Text("The Impact")
                        .font(.title2.weight(.bold))

                    Text("During Diwali, the excessive use of chemical firecrackers leads to a severe spike in air and noise pollution, affecting vulnerable people, local wildlife, and pets. Additionally, mass-produced plastic decorations often overshadow traditional, sustainable practices, harming the environment and local artisan economies.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .lineSpacing(5)

                    Divider()

                    Text("How You Can Help")
                        .font(.headline)
                        .foregroundStyle(.primary)

                    VStack(alignment: .leading, spacing: 18) {

                        ActionRow(
                            icon: "flame.fill",
                            color: .orange,
                            title: "Buy Clay Diyas",
                            subtitle: "Support local potters and avoid cheap plastic or electric alternatives."
                        )

                        ActionRow(
                            icon: "wind",
                            color: .gray,
                            title: "Breathe Clean",
                            subtitle: "Say no to toxic firecrackers to protect the air quality and local wildlife."
                        )

                        ActionRow(
                            icon: "leaf.fill",
                            color: .green,
                            title: "Natural Rangoli",
                            subtitle: "Use marigold petals, turmeric, and rice flour instead of chemical dyes."
                        )

                        ActionRow(
                            icon: "arrow.3.trianglepath",
                            color: .teal,
                            title: "Upcycled Decor",
                            subtitle: "Reuse old fabrics, paper, and glass bottles to create beautiful home decorations."
                        )
                    }
                    .padding(.top, 5)

                    Spacer(minLength: 120)
                }
                .padding(25)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .preferredColorScheme(.dark)
    }
}

struct ActionRow: View {

    let icon: String
    let color: Color
    let title: String
    let subtitle: String

    var body: some View {
        HStack(alignment: .top, spacing: 15) {

            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(color.gradient)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {

                Text(title)
                    .font(.headline.bold())
                    .foregroundStyle(.primary)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
