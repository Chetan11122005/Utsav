import SwiftUI

struct HomeView: View {

    @StateObject var data = FestivalData()
    @State private var selectedFestivalForSheet: Festival? = nil
    
    
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var showOnboarding = false

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 35) {

                    UpcomingTimelineView(
                        data: data,
                        selectedFestivalForSheet: $selectedFestivalForSheet
                    )
                    .padding(.top, 10)

                    VStack(alignment: .leading, spacing: 15) {

                        HStack {
                            Text("Nationwide Focus")
                                .font(.title3.bold())

                            Spacer()

                            NavigationLink(
                                destination: AllFestivalsListView(data: data)
                            ) {
                                HStack(spacing: 2) {
                                    Text("See All")
                                    Image(systemName: "chevron.right")
                                }
                                .font(.subheadline.bold())
                                .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.horizontal, 20)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(
                                    data.festivals.filter {
                                        $0.type == .national
                                    }
                                ) { festival in
                                    NavigationLink(
                                        destination: NationwideDetailView(
                                            festival: festival
                                        )
                                    ) {
                                        NationwideCard(festival: festival)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        }
                    }

                    VStack(alignment: .leading, spacing: 15) {

                        Text("Make a Difference")
                            .font(.title2.bold())
                            .padding(.horizontal, 20)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {

                                NavigationLink(
                                    destination: CommunityDetailView()
                                ) {
                                    DifferenceCard(
                                        category: "COMMUNITY",
                                        title: "The Joy of Langar Seva",
                                        description: "Discover how serving others brings the highest peace during Gurpurab.",
                                        colors: [
                                            .blue.opacity(0.8),
                                            .indigo,
                                            .black
                                        ]
                                    )
                                }

                                NavigationLink(
                                    destination: EnvironmentDetailView()
                                ) {
                                    DifferenceCard(
                                        category: "ENVIRONMENT",
                                        title: "Green Diwali",
                                        description: "Celebrating with light , protecting our air ",
                                        colors: [
                                            .teal.opacity(0.8),
                                            .green,
                                            .black
                                        ]
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }

                    Spacer(minLength: 100)
                }
                .padding(.top, 20)
            }
            .navigationTitle("Utsav")
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showOnboarding = true }) {
                        Image(systemName: "info.circle")
                            .font(.title3)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                }
            }
            .preferredColorScheme(.dark)
            .sheet(item: $selectedFestivalForSheet) { festival in
                TimelineDetailSheet(festival: festival)
                    .presentationDetents([.height(380)])
                    .presentationCornerRadius(35)
                    .presentationBackground {
                        ZStack {
                            Color.black
                            LinearGradient(
                                colors: [
                                    festival.color.opacity(0.5),
                                    .purple.opacity(0.3),
                                    .black
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .blur(radius: 40)
                        }
                    }
            }
                        .onAppear {
                if !hasSeenOnboarding {
                    showOnboarding = true
                }
            }
            .sheet(isPresented: $showOnboarding) {
                OnboardingView()
            }
        }
    }
}

struct MainUpcomingWidget: View {

    let festival: Festival

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            
            RoundedRectangle(cornerRadius: 20)
                .fill(festival.color.gradient)
            
            VStack {
                HStack {
                    Spacer()
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
                    .frame(width: 110, height: 110)
                    .foregroundStyle(.white.opacity(0.2))                     .offset(x: 25, y: -20)
                }
                Spacer()
            }
            .clipped()

            // 3. The Text Content Overlay
            VStack(alignment: .leading, spacing: 8) {
                
                Text("NEXT UP")
                    .font(.system(size: 10, weight: .black))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.ultraThinMaterial, in: Capsule())
                    .foregroundStyle(.white)

                Spacer()

                // The prominent Festival Name
                Text(festival.name)
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Text(festival.date)
                                    .font(.caption.bold())                                     .foregroundStyle(festival.color)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.white, in: Capsule()) 
            }
            .padding(16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .cornerRadius(20)
        .shadow(color: festival.color.opacity(0.4), radius: 10, y: 5)
    }
}
struct NationwideCard: View {

    let festival: Festival

    var body: some View {
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
                    EmptyView()
                }
            }

            LinearGradient(
                colors: [
                    .clear,
                    .clear,
                    .black.opacity(0.9)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 4) {

                Spacer()

                Text(festival.name)
                    .font(.title2.weight(.heavy))
                    .foregroundStyle(.white)
                    .lineLimit(1)

                HStack(spacing: 4) {
                    Image(systemName: "mappin.and.ellipse")
                    Text(festival.location)
                }
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white.opacity(0.8))
                .lineLimit(1)
            }
            .padding(16)
        }
        .frame(width: 170, height: 240)
        .background(festival.color.opacity(0.15))
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(festival.color, lineWidth: 2)
        )
        .shadow(
            color: festival.color.opacity(0.4),
            radius: 10,
            y: 5
        )
    }
}

struct SmallUpcomingWidget: View {

    let festival: Festival

    var body: some View {
        HStack(spacing: 12) {

            Image(systemName: festival.iconName)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 36, height: 36)
                .background(festival.color.gradient)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {

                Text(festival.name)
                    .font(.subheadline.bold())
                    .lineLimit(1)

                Text("\(festival.month.prefix(3).uppercased()) \(festival.day)")
                    .font(.caption2.bold())
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color(UIColor.secondarySystemGroupedBackground)
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    Color.primary.opacity(0.1),
                    lineWidth: 0.5
                )
        )
    }
}

struct DifferenceCard: View {

    let category: String
    let title: String
    let description: String
    let colors: [Color]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text(category)
                .font(.subheadline.weight(.heavy))
                .foregroundStyle(.white.opacity(0.7))

            Text(title)
                .font(.title.weight(.black))
                .foregroundStyle(.white)
                .minimumScaleFactor(0.8)

            Text(description)
                .font(.body)
                .foregroundStyle(.white.opacity(0.9))
                .lineLimit(3)
                .multilineTextAlignment(.leading)
        }
        .padding(25)
        .frame(width: 300, height: 210, alignment: .topLeading)
        .background(
            LinearGradient(
                colors: colors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(24)
        .shadow(
            color: colors[1].opacity(0.3),
            radius: 10,
            y: 5
        )
    }
}

struct TimelineDetailSheet: View {

    let festival: Festival
    @Environment(\.dismiss) var dismiss
    @State private var isReminderSet = false

    var body: some View {
        VStack(spacing: 16) {

            VStack(spacing: -8) {

                Text(festival.month.uppercased())
                    .font(.subheadline.weight(.black))
                    .foregroundStyle(festival.color)

                Text(festival.day)
                    .font(
                        .system(
                            size: 70,
                            weight: .bold,
                            design: .rounded
                        )
                    )
                    .foregroundStyle(.white)
            }
            .padding(.top, 25)

            VStack(spacing: 6) {

                Text(festival.name)
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.white)

                HStack(spacing: 4) {
                    Image(systemName: "mappin.and.ellipse")
                    Text(festival.location)
                }
                .font(.caption)
                .foregroundStyle(.white.opacity(0.7))
            }

            HStack(spacing: 15) {

                VStack(spacing: 8) {

                    Image(systemName: "hourglass")
                        .font(.title3)
                        .foregroundStyle(festival.color)

                    Text(calculateDaysLeft())
                        .font(.headline.bold())
                        .foregroundStyle(.white)

                    Text("Days Left")
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(.white.opacity(0.6))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.white.opacity(0.08))
                .cornerRadius(20)

                Button(action: {

                    withAnimation(
                        .spring(
                            response: 0.3,
                            dampingFraction: 0.6
                        )
                    ) {
                        isReminderSet.toggle()
                    }

                    UIImpactFeedbackGenerator(
                        style: .medium
                    ).impactOccurred()

                }) {
                    VStack(spacing: 8) {

                        Image(
                            systemName: isReminderSet
                                ? "bell.badge.fill"
                                : "bell.fill"
                        )
                        .font(.title3)
                        .foregroundStyle(
                            isReminderSet
                                ? .green
                                : festival.color
                        )
                        .scaleEffect(
                            isReminderSet ? 1.1 : 1.0
                        )

                        Text(isReminderSet ? "Set!" : "Remind")
                            .font(.headline.bold())
                            .foregroundStyle(.white)

                        Text(
                            isReminderSet
                                ? "Notify"
                                : "Notify Me"
                        )
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(.white.opacity(0.6))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        isReminderSet
                            ? Color.green.opacity(0.15)
                            : Color.white.opacity(0.08)
                    )
                    .cornerRadius(20)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 24)
            .padding(.top, 10)

            Spacer()

            Button(action: { dismiss() }) {
                Text("Done")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.cyan)
            }
            .padding(.bottom, 25)
        }
        .preferredColorScheme(.dark)
    }

    func calculateDaysLeft() -> String {

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd yyyy"

        let dateString = "\(festival.month) \(festival.day) 2026"

        guard let festivalDate = formatter.date(from: dateString) else {
            return "??"
        }

        let components = Calendar.current.dateComponents(
            [.day],
            from: Date(),
            to: festivalDate
        )

        if let days = components.day {
            return days < 0 ? "0" : "\(days)"
        }

        return "??"
    }
}

