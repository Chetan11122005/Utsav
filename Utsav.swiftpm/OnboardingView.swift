import SwiftUI

struct OnboardingView: View {

    @Environment(\.dismiss) var dismiss
    @AppStorage("hasSeenOnboarding")
    private var hasSeenOnboarding = false

    @State private var currentPage = 0

    var body: some View {
        ZStack {
            Color(white: 0.1)
                .ignoresSafeArea()

            VStack {

                HStack {
                    Spacer()

                    if currentPage < 2 {
                        Button("Skip") {
                            hasSeenOnboarding = true
                            dismiss()
                        }
                        .font(.body.weight(.semibold))
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 24)
                        .padding(.top, 15)
                    } else {
                        Color.clear
                            .frame(height: 44)
                    }
                }

                TabView(selection: $currentPage) {

                    OnboardingPage(
                        icon: "fireworks",
                        color: .pink,
                        title: "Welcome to Utsav",
                        description: "Discover the vibrant festivals of India through interactive and immersive experiences."
                    )
                    .tag(0)

                    OnboardingPage(
                        icon: "safari.fill",
                        color: .green,
                        title: "Discover by Theme",
                        description: "Uncover the deeper meanings behind our traditions—from nature and harvest to community and spirituality."
                    )
                    .tag(1)

                    OnboardingPage(
                        icon: "hand.tap.fill",
                        color: .yellow,
                        title: "Feel the Celebration",
                        description: "Interact with the screen to light diyas, spin wheels, and bloom flowers using haptics and sound."
                    )
                    .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .padding(.bottom, 20)

                Button {
                    if currentPage < 2 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        hasSeenOnboarding = true
                        dismiss()
                    }
                } label: {
                    Text(currentPage < 2 ? "Continue" : "Let's Celebrate")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.white)
                .foregroundColor(.black)
                .controlSize(.large)
                .buttonBorderShape(.capsule)
                .shadow(
                    color: .white.opacity(0.15),
                    radius: 15,
                    y: 5
                )
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPage: View {

    let icon: String
    let color: Color
    let title: String
    let description: String

    var body: some View {
        VStack(spacing: 20) {

            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 120, height: 120)
                    .blur(radius: 20)

                Image(systemName: icon)
                    .font(.system(size: 60, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(.bottom, 20)

            Text(title)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            Text(description)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.bottom, 60)
    }
}
