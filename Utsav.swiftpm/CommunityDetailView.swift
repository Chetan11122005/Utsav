import SwiftUI

struct CommunityDetailView: View {

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {

                ZStack(alignment: .bottomLeading) {

                    LinearGradient(
                        colors: [
                            Color.blue.opacity(0.8),
                            Color.indigo,
                            .black
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 350)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("COMMUNITY")
                            .font(.caption.weight(.heavy))
                            .foregroundStyle(.white.opacity(0.7))

                        Text("The Joy of Langar Seva")
                            .font(.system(size: 36, weight: .black))
                            .foregroundStyle(.white)
                    }
                    .padding(20)
                    .padding(.bottom, 10)
                }

                VStack(alignment: .leading, spacing: 20) {

                    Text("What is Langar?")
                        .font(.title2.bold())

                    Text("Langar is the community kitchen of a Gurdwara, which serves meals to all free of charge, regardless of religion, caste, gender, economic status, or ethnicity. People sit on the floor and eat together, and the kitchen is maintained entirely by community volunteers.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .lineSpacing(5)

                    Text("How to Participate")
                        .font(.title2.bold())
                        .padding(.top, 10)

                    VStack(alignment: .leading, spacing: 16) {
                        participationRow(
                            icon: "hands.sparkles.fill",
                            text: "Volunteer to cook or serve food."
                        )
                        participationRow(
                            icon: "leaf.fill",
                            text: "Donate raw ingredients like flour or lentils."
                        )
                        participationRow(
                            icon: "heart.fill",
                            text: "Help with cleaning the utensils (Seva)."
                        )
                    }

                    Spacer(minLength: 40)

                    NavigationLink(
                        destination: GurdwaraDirectoryView()
                    ) {
                        HStack {
                            Image(systemName: "book.pages.fill")
                            Text("Explore Historical Gurdwaras")
                        }
                        .font(.headline.bold())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.indigo)
                        .foregroundStyle(.white)
                        .cornerRadius(16)
                    }

                    Spacer(minLength: 60)
                }
                .padding(.horizontal, 20)
            }
        }
        .ignoresSafeArea(edges: .top)
        .preferredColorScheme(.dark)
    }

    @ViewBuilder
    func participationRow(
        icon: String,
        text: String
    ) -> some View {
        HStack(spacing: 15) {

            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.indigo)
                .frame(width: 44, height: 44)
                .background(Color.indigo.opacity(0.15))
                .clipShape(Circle())

            Text(text)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.primary)
        }
    }
}

struct HistoricalGurdwara: Identifiable {

    let id = UUID()
    let name: String
    let location: String
    let description: String
    let iconColor: Color
}

struct GurdwaraDirectoryView: View {

    let gurdwaras = [
        HistoricalGurdwara(
            name: "Sri Harmandir Sahib (Golden Temple)",
            location: "Amritsar, Punjab",
            description: "The holiest Gurdwara of Sikhism. Its Langar serves over 100,000 people every single day for free.",
            iconColor: .yellow
        ),
        HistoricalGurdwara(
            name: "Gurdwara Bangla Sahib",
            location: "New Delhi",
            description: "Known for its healing pool and massive community kitchen that feeds thousands of visitors across all faiths 24/7.",
            iconColor: .orange
        ),
        HistoricalGurdwara(
            name: "Gurdwara Hemkund Sahib",
            location: "Chamoli, Uttarakhand",
            description: "Located high in the Himalayas at 15,000 feet, volunteers brave extreme conditions to serve hot meals to pilgrims.",
            iconColor: .cyan
        ),
        HistoricalGurdwara(
            name: "Takht Sri Patna Sahib",
            location: "Patna, Bihar",
            description: "The birthplace of Guru Gobind Singh Ji, featuring a beautiful Langar hall that embodies equality and selfless service.",
            iconColor: .red
        )
    ]

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {

                Text("Historical Kitchens")
                    .font(.largeTitle.weight(.black))
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                Text("Discover the most iconic Gurdwaras in India where the tradition of Langar (free community kitchen) has been practiced for centuries.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 20)

                VStack(spacing: 16) {
                    ForEach(gurdwaras) { gurdwara in
                        GurdwaraCard(gurdwara: gurdwara)
                    }
                }
                .padding(.horizontal, 20)

                Spacer(minLength: 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(
            Color(UIColor.systemGroupedBackground)
        )
    }
}

struct GurdwaraCard: View {

    let gurdwara: HistoricalGurdwara

    var body: some View {
        HStack(alignment: .top, spacing: 15) {

            Image(systemName: "building.columns.fill")
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 50, height: 50)
                .background(gurdwara.iconColor.gradient)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 12,
                        style: .continuous
                    )
                )

            VStack(alignment: .leading, spacing: 6) {

                Text(gurdwara.name)
                    .font(.headline.bold())
                    .foregroundStyle(.primary)

                HStack(spacing: 4) {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.caption)

                    Text(gurdwara.location)
                        .font(.caption.weight(.semibold))
                }
                .foregroundStyle(.secondary)

                Text(gurdwara.description)
                    .font(.subheadline)
                    .foregroundStyle(.primary.opacity(0.8))
                    .lineSpacing(4)
                    .padding(.top, 4)
            }

            Spacer(minLength: 0)
        }
        .padding(16)
        .background(
            Color(UIColor.secondarySystemGroupedBackground)
        )
        .cornerRadius(20)
        .shadow(
            color: .black.opacity(0.05),
            radius: 8,
            y: 4
        )
    }
}
