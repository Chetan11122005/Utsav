import SwiftUI

struct TalesView: View {

    @StateObject var talesData = TalesData()

    var body: some View {
        NavigationView {
            List {

                if !talesData.tales.filter({ $0.isLiked }).isEmpty {

                    Section(
                        header:
                            Text("My Favorites")
                                .font(.title3.bold())
                                .foregroundStyle(.primary)
                                .textCase(nil)
                                .padding(.bottom, 8)
                                .padding(.horizontal, 20)
                    ) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {

                                ForEach(
                                    talesData.tales.filter { $0.isLiked }
                                ) { tale in

                                    ZStack(alignment: .topTrailing) {

                                        NavigationLink(
                                            destination: TaleDetailView(
                                                tale: tale,
                                                data: talesData
                                            )
                                        ) {
                                            VStack(spacing: 12) {

                                                Image(systemName: tale.image)
                                                    .font(.system(size: 35))
                                                    .foregroundStyle(tale.color)
                                                    .frame(width: 80, height: 80)
                                                    .background(
                                                        tale.color.opacity(0.1)
                                                    )
                                                    .clipShape(Circle())

                                                Text(tale.festivalName)
                                                    .font(.headline)
                                                    .foregroundStyle(.primary)
                                            }
                                            .padding(.vertical, 15)
                                            .padding(.horizontal, 10)
                                            .frame(width: 120)
                                            .background(
                                                Color(uiColor: .systemGray6)
                                            )
                                            .cornerRadius(16)
                                        }
                                        .buttonStyle(.plain)
                                        .contextMenu {
                                            Button(role: .destructive) {
                                                removeFavorite(tale: tale)
                                            } label: {
                                                Label(
                                                    "Remove from Favorites",
                                                    systemImage: "heart.slash"
                                                )
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                        }
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }

                Section(
                    header:
                        Text("The Chronicles")
                            .font(.title3.bold())
                            .foregroundStyle(.primary)
                            .textCase(nil)
                            .padding(.top, 10)
                ) {

                    ForEach(talesData.tales) { tale in

                        NavigationLink(
                            destination: TaleDetailView(
                                tale: tale,
                                data: talesData
                            )
                        ) {
                            HStack(spacing: 20) {

                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(
                                            tale.color.opacity(0.15)
                                        )
                                        .frame(width: 75, height: 75)

                                    Image(systemName: tale.image)
                                        .font(.title)
                                        .foregroundStyle(tale.color)
                                }

                                VStack(
                                    alignment: .leading,
                                    spacing: 6
                                ) {
                                    Text(tale.festivalName)
                                        .font(.title3.bold())

                                    HStack(spacing: 6) {

                                        if tale.isLiked {
                                            Image(systemName: "heart.fill")
                                                .font(.subheadline)
                                                .foregroundStyle(.red)
                                        }

                                        Text(tale.headline)
                                            .font(.body)
                                            .foregroundStyle(.secondary)
                                            .lineLimit(1)
                                    }
                                }
                            }
                            .padding(.vertical, 12)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Tales of India")
        }
    }

    private func removeFavorite(tale: Tale) {

        UIImpactFeedbackGenerator(style: .medium)
            .impactOccurred()

        withAnimation(
            .spring(response: 0.3, dampingFraction: 0.7)
        ) {
            if let index = talesData.tales.firstIndex(
                where: { $0.id == tale.id }
            ) {
                talesData.tales[index].isLiked = false
            }
        }
    }
}
