import SwiftUI
import StoreKit
import AppTrackingTransparency

struct OnboardingViewSX: View {
    @AppStorage("hasCompletedOnboardingSX") private var hasCompleted: Bool = false
    @AppStorage("hasRequestedReviewSX") private var hasRequestedReview: Bool = false
    @AppStorage("hasRequestedATTSX") private var hasRequestedATT: Bool = false
    @AppStorage("usernameSX") private var username: String = ""
    @State private var currentPage: Int = 0
    @State private var nameInput: String = ""
    @State private var slideOffset: CGFloat = 0
    @State private var contentOpacity: Double = 1.0

    let pages = OnboardingPageSX.all
    let onFinish: () -> Void

    var body: some View {
        ZStack {
            GradientSX.background.ignoresSafeArea()

            GeometryReader { geometry in
                let imageName = pages[currentPage].backgroundImage
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .animation(.easeInOut(duration: 0.5), value: currentPage)
            }
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: adaptyH(28)) {
                    VStack(spacing: adaptyH(24)) {
                        VStack(spacing: 14) {
                            Text(pages[currentPage].emoji)
                                .font(.system(size: 64))
                            Text(pages[currentPage].title)
                                .font(FontSX.display(28))
                                .foregroundStyle(GradientSX.goldText)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, adaptyW(16))
                            Text(pages[currentPage].subtitle)
                                .font(FontSX.body(15))
                                .foregroundStyle(ColorSX.textSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, adaptyW(16))
                        }
                        .opacity(contentOpacity)
                        .offset(x: slideOffset)

                        if currentPage == 1 {
                            VStack(spacing: 8) {
                                Text("Your name")
                                    .font(FontSX.caption(13))
                                    .foregroundStyle(ColorSX.textMuted)
                                TextField("Enter your name", text: $nameInput)
                                    .font(FontSX.body(16))
                                    .foregroundStyle(ColorSX.textPrimary)
                                    .multilineTextAlignment(.center)
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(ColorSX.surface)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 14)
                                                    .strokeBorder(ColorSX.accent.opacity(0.3), lineWidth: 1)
                                            )
                                    )
                                    .padding(.horizontal, adaptyW(16))
                            }
                            .opacity(contentOpacity)
                        }

                        HStack(spacing: 8) {
                            ForEach(0..<pages.count, id: \.self) { i in
                                Capsule()
                                    .fill(i == currentPage ? ColorSX.accent : ColorSX.separator)
                                    .frame(width: i == currentPage ? adaptyW(24) : 8, height: 8)
                                    .animation(.spring(response: 0.3), value: currentPage)
                            }
                        }

                        Button(action: advance) {
                            HStack {
                                Text(currentPage == pages.count - 1 ? "Start" : "Continue")
                                Image(systemName: "chevron.right")
                            }
                            .font(FontSX.label(17))
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: adaptyH(56))
                            .background(GradientSX.gold)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: ColorSX.accentGold.opacity(0.4), radius: 12, y: 4)
                        }
                    }
                    .padding(adaptyW(24))
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 32)
                                .fill(ColorSX.surface.opacity(0.75))
                            RoundedRectangle(cornerRadius: 32)
                                .fill(.ultraThinMaterial)
                        }
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 32)
                            .strokeBorder(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.2), Color.clear, Color.white.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                    .padding(.horizontal, adaptyW(20))
                    .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
                }
                .padding(.bottom, adaptyH(50))
            }
        }
    }

    func advance() {
        
        if currentPage == 1 && !nameInput.isEmpty {
            username = nameInput
        }

        
        if currentPage == 0 {
            requestReviewPrompt()
        } else if currentPage == 1 {
            requestATTPrompt()
        }

        
        if currentPage == pages.count - 1 {
            hasCompleted = true
            onFinish()
            return
        }

        
        withAnimation(.easeInOut(duration: 0.2)) {
            contentOpacity = 0
            slideOffset = -30
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            currentPage += 1
            slideOffset = 30
            withAnimation(.spring(response: 0.4)) {
                contentOpacity = 1
                slideOffset = 0
            }
        }
    }

    private func requestReviewPrompt() {
        guard !hasRequestedReview else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let windowScene = UIApplication.shared.connectedScenes
                .filter({ $0.activationState == .foregroundActive })
                .compactMap({ $0 as? UIWindowScene })
                .first {
                SKStoreReviewController.requestReview(in: windowScene)
                hasRequestedReview = true
            }
        }
    }

    private func requestATTPrompt() {
        guard !hasRequestedATT else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ATTrackingManager.requestTrackingAuthorization { status in
                DispatchQueue.main.async {
                    hasRequestedATT = true
                }
            }
        }
    }
}

struct OnboardingPageSX {
    let emoji: String
    let title: String
    let subtitle: String
    let backgroundImage: String

    static let all: [OnboardingPageSX] = [
        OnboardingPageSX(
            emoji: "🐎",
            title: "Welcome to Speed Rodeo SX",
            subtitle: "Your premium equestrian training platform. Master the art of horse racing through interactive simulators, in-depth knowledge, and expert training protocols.",
            backgroundImage: "onbOne"
        ),
        OnboardingPageSX(
            emoji: "🏆",
            title: "Build Your Profile",
            subtitle: "Tell us your name to personalize your journey. Track your progress, earn badges, and compete in weekly challenges.",
            backgroundImage: "onbTwo"
        ),
        OnboardingPageSX(
            emoji: "📚",
            title: "Learn Like a Professional",
            subtitle: "Access 20 expert articles, 10 hands-on training tasks, and a full horse breed encyclopedia, all available completely offline.",
            backgroundImage: "onbThree"
        ),
        OnboardingPageSX(
            emoji: "⚡",
            title: "Simulate and Strategize",
            subtitle: "Run training simulations, build race strategies, and design nutrition plans to prepare yourself for the highest level of equestrian competition.",
            backgroundImage: "onbThree"
        )
    ]
}

#Preview {
    OnboardingViewSX {}
}
