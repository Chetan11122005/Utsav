import SwiftUI

struct NationwideDetailView: View {

    let festival: Festival
    @Environment(\.dismiss) var dismiss

    @State private var showCelebration = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {

                ZStack(alignment: .bottomLeading) {

                    GeometryReader { geo in
                        if UIImage(named: festival.name) != nil {
                            Image(festival.name)
                                .resizable()
                                .scaledToFill()
                                .frame(
                                    width: geo.size.width,
                                    height: geo.size.height
                                )
                                .clipped()
                        } else {
                            Rectangle()
                                .fill(festival.color.gradient)
                        }
                    }
                    .frame(height: 400)

                    LinearGradient(
                        colors: [
                            .clear,
                            .black.opacity(0.4),
                            .black.opacity(0.95)
                        ],
                        startPoint: .center,
                        endPoint: .bottom
                    )
                    .frame(height: 400)

                    VStack(alignment: .leading, spacing: 5) {

                        Text(festival.name)
                            .font(
                                .system(
                                    size: 45,
                                    weight: .heavy
                                )
                            )
                            .foregroundStyle(.white)
                            .shadow(
                                color: .black.opacity(0.3),
                                radius: 5,
                                y: 3
                            )

                        HStack(spacing: 6) {
                            Image(systemName: "mappin.and.ellipse")
                            Text(festival.location)
                        }
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.9))
                    }
                    .padding(25)
                    .padding(.bottom, 10)
                }
                .frame(height: 400)

                VStack(alignment: .leading, spacing: 25) {

                    Text(festival.description)
                        .font(.title3)
                        .lineSpacing(6)
                        .opacity(0.9)
                        .padding(.top, 10)

                    Divider()
                        .background(
                            Color.white.opacity(0.2)
                        )

                    if !festival.rituals.isEmpty {

                        Text("Key Rituals")
                            .font(.headline)
                            .textCase(.uppercase)
                            .foregroundStyle(.secondary)

                        ForEach(
                            festival.rituals,
                            id: \.self
                        ) { ritual in
                            HStack(alignment: .top) {

                                Image(systemName: "diamond.fill")
                                    .font(.system(size: 10))
                                    .foregroundStyle(festival.color)
                                    .padding(.top, 6)

                                Text(ritual)
                                    .font(.body)
                            }
                        }
                    }

                    Button(action: {
                        showCelebration = true
                    }) {
                        HStack {

                            Image(
                                systemName:
                                    festival.name == "Diwali"
                                        ? "sparkles"
                                        : "party.popper.fill"
                            )
                            .font(.title2)

                            Text(
                                festival.name == "Diwali"
                                    ? "Light the Diya"
                                    : "Celebrate Now"
                            )
                            .font(.title3.bold())
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(festival.color.gradient)
                        .foregroundStyle(.white)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 16)
                        )
                        .shadow(
                            color: festival.color.opacity(0.4),
                            radius: 10,
                            y: 5
                        )
                    }
                    .padding(.top, 20)

                    Spacer(minLength: 120)
                }
                .padding(25)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .preferredColorScheme(.dark)
        .fullScreenCover(
            isPresented: $showCelebration
        ) {
            if festival.name == "Holi" {
                HoliCelebrationView()
            } else if festival.name == "Eid al-Fitr" {
                EidCelebrationView()
            } else {
                CelebrationView(festival: festival)
            }
        }
    }
}
