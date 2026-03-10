import SwiftUI
import SwiftData

struct MainViewSX: View {
    @AppStorage("hasCompletedOnboardingSX") private var hasCompletedOnboarding: Bool = false
    @State private var viewModel = MainViewModelSX()
    @State private var iap = IAPManagerVE.shared
    @State private var showSplash = true

    var body: some View {
        ZStack {
            if showSplash {
                SplashViewSX {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showSplash = false
                    }
                }
                .transition(.opacity)
                .zIndex(10)
            } else if !hasCompletedOnboarding {
                OnboardingViewSX {
                    hasCompletedOnboarding = true
                }
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
            } else {
                mainContent
                    .transition(.opacity)
            }
        }
        .preferredColorScheme(.dark)
    }

    @ViewBuilder
    var mainContent: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch viewModel.selectedTab {
                case .home:
                    HomeViewSX()
                case .journal:
                    JournalViewSX()
                case .search:
                    SearchViewSX()
                case .favorites:
                    FavoritesViewSX()
                case .settings:
                    SettingsViewSX()
                }
            }
            .environment(viewModel)
            .environment(iap)
            .transition(.opacity)
            .animation(.easeInOut(duration: 0.2), value: viewModel.selectedTab)

            CustomTabBarSX(selectedTab: Bindable(viewModel).selectedTab)
        }
        .ignoresSafeArea(edges: .bottom)
        .sheet(isPresented: $viewModel.showPaywall) {
            PaywallViewSX()
                .environment(viewModel)
                .environment(iap)
        }
    }
}

#Preview {
    MainViewSX()
        .modelContainer(for: [UserStatsSX.self, CompletedTaskSX.self, FavoriteItemSX.self], inMemory: true)
}
