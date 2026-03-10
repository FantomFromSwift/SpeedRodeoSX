import SwiftUI

struct SettingsViewSX: View {
    @Environment(MainViewModelSX.self) private var viewModel
    @Environment(IAPManagerVE.self) private var iap
    @Environment(ThemeManagerSX.self) private var themeManager
    @AppStorage("usernameSX") private var username: String = ""
    @State private var showPaywall = false
    @State private var showAbout = false
    @State private var showVideo = false
    @State private var showStats = false

    let themeOptions: [(name: String, id: String, color: Color, gradient: LinearGradient, theme: AppThemeSX)] = [
        ("Classic SX", "classic", Color(red: 1.0, green: 0.78, blue: 0.20), LinearGradient(colors: [Color(red: 0.04, green: 0.04, blue: 0.12), Color(red: 0.07, green: 0.04, blue: 0.18)], startPoint: .top, endPoint: .bottom), .classic),
        ("Desert Gold", "desertGold", Color(red: 0.95, green: 0.72, blue: 0.25), GradientSX.desertTheme, .desert),
        ("Royal Stable", "royalStable", Color(red: 0.65, green: 0.45, blue: 1.0), GradientSX.royalTheme, .royal),
        ("Midnight Track", "midnightTrack", Color(red: 0.35, green: 0.65, blue: 1.0), GradientSX.midnightTheme, .midnight)
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                AnimatedBackgroundSX()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: adaptyH(22)) {
                        headerSection
                        profileSection
                        themeSection
                        actionsSection
                        Spacer().frame(height: adaptyH(100))
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
            }
            .navigationDestination(isPresented: $showStats) {
                StatsViewSX()
            }
            .navigationDestination(isPresented: $showAbout) {
                AboutViewSX()
            }
            .navigationDestination(isPresented: $showVideo) {
                VideoViewSX()
            }
            .sheet(isPresented: $showPaywall) {
                PaywallViewSX()
                    .environment(viewModel)
                    .environment(iap)
                    .environment(themeManager)
            }
            .onAppear {
                iap.fetchProducts()
            }
        }
    }

    var headerSection: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Settings")
                    .font(FontSX.display(30))
                    .foregroundStyle(GradientSX.goldText)
            }
            Spacer()
            Image(systemName: "paintpalette.fill")
                .font(.system(size: 26))
                .foregroundStyle(GradientSX.gold)
        }
    }

    var profileSection: some View {
        GlowingCardSX(glowColor: ColorSX.accent) {
            HStack(spacing: 14) {
                ZStack {
                    Circle().fill(ColorSX.accent.opacity(0.12)).frame(
                        width: adaptyW(54),
                        height: adaptyH(54)
                    )
                    Image(systemName: "person.fill").font(.system(size: 24))
                        .foregroundStyle(GradientSX.gold)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(username.isEmpty ? "Rider" : username)
                        .font(FontSX.headline(18))
                        .foregroundStyle(ColorSX.textPrimary)
                    Text("Speed Rodeo SX Rider")
                        .font(FontSX.body(13))
                        .foregroundStyle(ColorSX.textSecondary)
                }
                Spacer()
            }
        }
    }

    var themeSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: "swatchpalette.fill").foregroundStyle(
                    ColorSX.accent
                )
                Text("App Themes").font(FontSX.label(15)).foregroundStyle(
                    ColorSX.textPrimary
                )
            }
            ForEach(themeOptions, id: \.id) { theme in
                themeRow(option: theme)
            }
        }
    }

    func themeRow(option: (name: String, id: String, color: Color, gradient: LinearGradient, theme: AppThemeSX)) -> some View {
        let isOwned = option.id == "classic" || iap.isPurchased(option.id)
        let isActive = themeManager.currentTheme == option.theme
        
        return HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 10)
                .fill(option.gradient)
                .frame(width: adaptyW(54), height: adaptyH(38))
                .overlay(
                    RoundedRectangle(cornerRadius: 10).strokeBorder(
                        option.color.opacity(0.3),
                        lineWidth: 1
                    )
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(option.name)
                    .font(FontSX.headline(16))
                    .foregroundStyle(ColorSX.textPrimary)
                
                if !isOwned {
                    Text("Premium")
                        .font(FontSX.caption(10))
                        .foregroundStyle(ColorSX.accent)
                }
            }
            
            Spacer()
            
            if isActive {
                Label("Active", systemImage: "checkmark.circle.fill")
                    .font(FontSX.label(13))
                    .foregroundStyle(ColorSX.positive)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(ColorSX.positive.opacity(0.1))
                    .clipShape(Capsule())
            } else if isOwned {
                Button {
                    withAnimation(.spring()) {
                        themeManager.currentTheme = option.theme
                    }
                } label: {
                    Text("Select")
                        .font(FontSX.label(13))
                        .foregroundStyle(ColorSX.accent)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(ColorSX.accent.opacity(0.1))
                        .clipShape(Capsule())
                }
            } else {
                Image(systemName: "lock.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(ColorSX.textMuted)
                    .padding(8)
                    .background(ColorSX.surfaceElevated)
                    .clipShape(Circle())
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isActive ? ColorSX.surfaceElevated : ColorSX.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(
                            isActive ? option.color.opacity(0.5) : Color.clear,
                            lineWidth: 1.5
                        )
                )
        )
        .onTapGesture {
            if !isOwned {
                showPaywall = true
            } else if !isActive {
                withAnimation(.spring()) {
                    themeManager.currentTheme = option.theme
                }
            }
        }
    }

    var actionsSection: some View {
        VStack(spacing: 12) {
            settingsRow(
                icon: "chart.bar.fill",
                label: "Statistics",
                color: ColorSX.glowBlue
            ) { showStats = true }
            settingsRow(
                icon: "play.rectangle.fill",
                label: "Watch Video",
                color: ColorSX.glowOrange
            ) { showVideo = true }
            settingsRow(
                icon: "info.circle.fill",
                label: "About",
                color: ColorSX.glowPurple
            ) { showAbout = true }
            Button {
                iap.restorePurchases()
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(ColorSX.positive)
                    Text("Restore Purchases")
                        .font(FontSX.body(15))
                        .foregroundStyle(ColorSX.textPrimary)
                    Spacer()
                    if iap.isLoading {
                        ProgressView().tint(ColorSX.positive)
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 14).fill(ColorSX.surface)
                )
            }
            .buttonStyle(.plain)
        }
    }

    func settingsRow(
        icon: String,
        label: String,
        color: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon).font(.system(size: 20)).foregroundStyle(
                    color
                )
                Text(label).font(FontSX.body(15)).foregroundStyle(
                    ColorSX.textPrimary
                )
                Spacer()
                Image(systemName: "chevron.right").font(.system(size: 12))
                    .foregroundStyle(ColorSX.textMuted)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 14).fill(ColorSX.surface)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SettingsViewSX()
        .environment(MainViewModelSX())
        .environment(IAPManagerVE.shared)
}
