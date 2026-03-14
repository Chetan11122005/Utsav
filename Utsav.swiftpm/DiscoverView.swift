import SwiftUI

struct DiscoverView: View {

    @StateObject var data = FestivalData()

    @State private var rotation: Double = 0
    @State private var activeCategory: FestivalCategory = .community
    @State private var isSpinning = false

    let impactMed = UIImpactFeedbackGenerator(style: .medium)
    let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)

    var body: some View {
        NavigationView {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    getCategoryColor(activeCategory)
                        .opacity(0.08)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 25) {
                        
                        VStack(spacing: 8) {
                            Text("EXPLORE FESTIVALS")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.secondary)
                                .tracking(2)
                            
                            Text(getCategoryName(activeCategory))
                                .font(.system(size: 34, weight: .bold))
                                .foregroundStyle(getCategoryColor(activeCategory))
                                .contentTransition(.numericText())
                                .animation(.snappy, value: activeCategory)
                        }
                        .padding(.top, 10)
                        
                        ZStack {
                            
                            Image(systemName: "arrowtriangle.down.fill")
                                .font(.title3)
                                .foregroundStyle(.primary.opacity(0.8))
                                .offset(y: -145)
                                .zIndex(10)
                            
                            ZStack {
                                
                                Circle()
                                    .strokeBorder(
                                        AngularGradient(
                                            gradient: Gradient(
                                                colors: [.green, .pink, .blue, .purple, .green]
                                            ),
                                            center: .center
                                        ),
                                        lineWidth: 25
                                    )
                                    .frame(width: 260, height: 260)
                                    .shadow(
                                        color: .black.opacity(0.15),
                                        radius: 15,
                                        x: 0,
                                        y: 10
                                    )
                                
                                iconView(icon: "leaf.fill", color: .green, angle: 0)
                                iconView(icon: "figure.mind.and.body", color: .purple, angle: 90)
                                iconView(icon: "cloud.sun", color: .blue, angle: 180)
                                iconView(icon: "figure.2.and.child.holdinghands", color: .pink, angle: 270)
                            }
                            .rotationEffect(.degrees(rotation))
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        if !isSpinning {
                                            changeRotation(value: value)
                                        }
                                    }
                                    .onEnded { _ in
                                        if !isSpinning {
                                            snapToNearestCategory()
                                        }
                                    }
                            )
                            
                            Button(action: spinRandomly) {
                                ZStack {
                                    
                                    Circle()
                                        .fill(.regularMaterial)
                                        .frame(width: 100, height: 100)
                                        .shadow(color: .black.opacity(0.1), radius: 5)
                                    
                                    VStack(spacing: 2) {
                                        
                                        Image(systemName: "arrow.triangle.2.circlepath")
                                            .font(.title2)
                                            .foregroundStyle(.primary)
                                            .rotationEffect(.degrees(isSpinning ? 360 : 0))
                                            .animation(
                                                isSpinning
                                                ? .linear(duration: 1).repeatForever(autoreverses: false)
                                                : .default,
                                                value: isSpinning
                                            )
                                        
                                        Text("SPIN")
                                            .font(.caption.bold())
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                            .disabled(isSpinning)
                        }
                        .padding(.vertical, 10)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            
                            HStack {
                                Text("Featured in \(getCategoryName(activeCategory))")
                                    .font(.headline)
                                    .foregroundStyle(.secondary)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    
                                    let filtered = data.festivals.filter {
                                        $0.category == activeCategory
                                    }
                                    
                                    if filtered.isEmpty {
                                        emptyStateView()
                                    } else {
                                        ForEach(filtered) { festival in
                                            NavigationLink(
                                                destination: NationwideDetailView(
                                                    festival: festival
                                                )
                                            ) {
                                                DiscoverCard(festival: festival)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.bottom, 20)
                            }
                        }
                        
                        Spacer()
                    }
                }
                .navigationTitle("Discover")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    func spinRandomly() {

        isSpinning = true
        impactHeavy.impactOccurred()

        let extraSpins = Double(Int.random(in: 2...4)) * 360
        let randomAngle = [0.0, 90.0, 180.0, 270.0].randomElement()!
        let targetRotation = rotation - extraSpins - randomAngle

        withAnimation(.timingCurve(0.1, 0.8, 0.2, 1.0, duration: 2.5)) {
            rotation = targetRotation
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            isSpinning = false
            snapToNearestCategory()
            impactHeavy.impactOccurred()
        }
    }

    func iconView(
        icon: String,
        color: Color,
        angle: Double
    ) -> some View {

        ZStack {

            Circle()
                .fill(.background)
                .frame(width: 44, height: 44)
                .shadow(color: .black.opacity(0.1), radius: 2)

            Image(systemName: icon)
                .foregroundStyle(color)
                .font(.body.bold())
        }
        .offset(x: 130)
        .rotationEffect(.degrees(angle))
    }

    func changeRotation(value: DragGesture.Value) {

        let vector = CGVector(
            dx: value.location.x - 130,
            dy: value.location.y - 130
        )

        let angle = atan2(vector.dy, vector.dx) * 180 / .pi

        withAnimation(.linear(duration: 0.01)) {
            rotation = angle
        }
    }

    func snapToNearestCategory() {

        let current = rotation.truncatingRemainder(dividingBy: 360)
        let normalized = current < 0 ? current + 360 : current

        let remainder = normalized.truncatingRemainder(dividingBy: 90)
        let snapAdjustment = remainder > 45 ? (90 - remainder) : -remainder

        let finalRotation = rotation + snapAdjustment

        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            rotation = finalRotation
        }

        updateActiveCategory(angle: finalRotation)
    }

    func updateActiveCategory(angle: Double) {

        let current = angle.truncatingRemainder(dividingBy: 360)
        let normalized = current < 0 ? current + 360 : current

        if normalized >= 315 || normalized < 45 {
            activeCategory = .community
        } else if normalized >= 45 && normalized < 135 {
            activeCategory = .nature
        } else if normalized >= 135 && normalized < 225 {
            activeCategory = .religious
        } else {
            activeCategory = .harvest
        }

        impactMed.impactOccurred()
    }

    func emptyStateView() -> some View {

        VStack(spacing: 8) {

            Image(systemName: "sparkles")
                .font(.largeTitle)
                .foregroundStyle(.tertiary)

            Text("Coming Soon")
                .font(.caption.bold())
                .foregroundStyle(.secondary)
        }
        .frame(width: 180, height: 150)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(16)
    }

    func getCategoryName(_ cat: FestivalCategory) -> String {
        switch cat {
        case .harvest:
            return "Harvest"
        case .community:
            return "Community"
        case .nature:
            return "Nature"
        case .religious:
            return "Spiritual"
        }
    }

    func getCategoryColor(_ cat: FestivalCategory) -> Color {
        switch cat {
        case .harvest:
            return .green
        case .community:
            return .pink
        case .nature:
            return .blue
        case .religious:
            return .purple
        }
    }
}

struct DiscoverCard: View {

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
                    Rectangle()
                        .fill(festival.color.gradient)
                }
            }

            LinearGradient(
                colors: [
                    .clear,
                    .black.opacity(0.3),
                    .black.opacity(0.95)
                ],
                startPoint: .center,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 4) {

                Spacer()

                Text(festival.name)
                    .font(.headline.weight(.heavy))
                    .foregroundStyle(.white)
                    .lineLimit(1)

                HStack(spacing: 4) {
                    Image(systemName: "mappin.and.ellipse")
                    Text(festival.location)
                }
                .font(.caption2.weight(.bold))
                .foregroundStyle(.white.opacity(0.8))
                .lineLimit(1)
            }
            .padding(12)
        }
        .frame(width: 150, height: 190)
        .background(festival.color.opacity(0.3))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    festival.color.opacity(0.6),
                    lineWidth: 1.5
                )
        )
        .shadow(
            color: festival.color.opacity(0.2),
            radius: 8,
            y: 5
        )
    }
}
