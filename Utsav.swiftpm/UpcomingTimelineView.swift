import SwiftUI

struct UpcomingTimelineView: View {

    @ObservedObject var data: FestivalData
    @Binding var selectedFestivalForSheet: Festival?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            Text("UPCOMING")
                .font(.caption.weight(.heavy))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 20)

            if data.festivals.count >= 3 {

                let upcoming = Array(data.festivals.prefix(3))

                HStack(spacing: 15) {

                    MainUpcomingWidget(festival: upcoming[0])
                        .onTapGesture {
                            UIImpactFeedbackGenerator(
                                style: .light
                            ).impactOccurred()
                            selectedFestivalForSheet = upcoming[0]
                        }

                    VStack(spacing: 15) {

                        SmallUpcomingWidget(festival: upcoming[1])
                            .onTapGesture {
                                UIImpactFeedbackGenerator(
                                    style: .light
                                ).impactOccurred()
                                selectedFestivalForSheet = upcoming[1]
                            }

                        SmallUpcomingWidget(festival: upcoming[2])
                            .onTapGesture {
                                UIImpactFeedbackGenerator(
                                    style: .light
                                ).impactOccurred()
                                selectedFestivalForSheet = upcoming[2]
                            }
                    }
                }
                .frame(height: 160)
                .padding(.horizontal, 20)
            }
        }
        .padding(.top, 10)
    }
}
