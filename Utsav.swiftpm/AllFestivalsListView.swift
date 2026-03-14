import SwiftUI

struct AllFestivalsListView: View {

    @ObservedObject var data: FestivalData

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(data.festivals) { festival in
                    NavigationLink(
                        destination: NationwideDetailView(festival: festival)
                    ) {
                        FestivalRowCard(festival: festival)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
        .background(
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
        )
        .navigationTitle("Nationwide Focus")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FestivalRowCard: View {

    let festival: Festival

    var body: some View {
        HStack(spacing: 16) {

            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(festival.color.opacity(0.2))
                    .frame(width: 70, height: 70)

                Group {
                    if UIImage(named: festival.iconName) != nil {
                        Image(festival.iconName)
                            .renderingMode(.template)
                            .resizable()
                    } else {
                        Image(systemName: festival.iconName)
                            .resizable()
                    }
                }
                .scaledToFit()
                .frame(width: 35, height: 35)
                .foregroundStyle(festival.color)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(festival.name)
                    .font(.title3.bold())
                    .foregroundStyle(.primary)

                Text(festival.date)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.subheadline.bold())
                .foregroundStyle(.gray.opacity(0.5))
        }
        .padding(12)
        .background(
            Color(uiColor: .secondarySystemGroupedBackground)
        )
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    Color.primary.opacity(0.1),
                    lineWidth: 0.5
                )
        )
    }
}
