import SwiftUI

@main
struct FestivalApp: App {

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}

struct MainTabView: View {

    init() {
        let appearance = UITabBarAppearance()

        appearance.configureWithDefaultBackground()
        appearance.backgroundEffect = UIBlurEffect(
            style: .systemUltraThinMaterial
        )

        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView {

            HomeView()
                .tabItem {
                    Label(
                        "Home",
                        systemImage: "house.fill"
                    )
                }

            DiscoverView()
                .tabItem {
                    Label(
                        "Discover",
                        systemImage: "safari.fill"
                    )
                }

            TalesView()
                .tabItem {
                    Label(
                        "Tales",
                        systemImage: "book.closed.fill"
                    )
                }
        }
        .accentColor(.purple)
        .preferredColorScheme(.dark)
    }
}
