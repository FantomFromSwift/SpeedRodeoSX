import SwiftUI
import StoreKit

struct PaywallViewSX: View {
    @Environment(MainViewModelSX.self) private var viewModel
    @Environment(IAPManagerVE.self) private var iap
    @Environment(ThemeManagerSX.self) private var themeManager
    @Environment(\.dismiss) private var dismiss
    @State private var purchasing: String? = nil

    let offerings: [(title: String, subtitle: String, id: String, color: Color, gradient: LinearGradient, theme: AppThemeSX)] = [
        ("Classic SX", "The original Speed Rodeo aesthetic.", "classic", Color(red: 1.0, green: 0.78, blue: 0.20), LinearGradient(colors: [Color(red: 0.04, green: 0.04, blue: 0.12), Color(red: 0.07, green: 0.04, blue: 0.18)], startPoint: .top, endPoint: .bottom), .classic),
        ("Desert Gold", "Warm golden dunes — premium sandy tones.", "desertGold", Color(red: 0.95, green: 0.72, blue: 0.25), LinearGradient(colors: [Color(red: 0.20, green: 0.14, blue: 0.05), Color(red: 0.10, green: 0.08, blue: 0.02)], startPoint: .topLeading, endPoint: .bottomTrailing), .desert),
        ("Royal Stable", "Rich purple throne room elegance.", "royalStable", Color(red: 0.65, green: 0.45, blue: 1.0), LinearGradient(colors: [Color(red: 0.18, green: 0.08, blue: 0.35), Color(red: 0.10, green: 0.04, blue: 0.20)], startPoint: .topLeading, endPoint: .bottomTrailing), .royal),
        ("Midnight Track", "Deep blue midnight race circuit theme.", "midnightTrack", Color(red: 0.35, green: 0.65, blue: 1.0), LinearGradient(colors: [Color(red: 0.04, green: 0.10, blue: 0.25), Color(red: 0.02, green: 0.05, blue: 0.15)], startPoint: .topLeading, endPoint: .bottomTrailing), .midnight)
    ]

    var body: some View {
        ZStack {
            AnimatedBackgroundSX()
            VStack(spacing: 0) {
                topBar
                ScrollView(showsIndicators: false) {
                    VStack(spacing: adaptyH(24)) {
                        heroSection
                        offersSection
                        restoreButton
                        footerText
                        Spacer().frame(height: adaptyH(60))
                    }
                    .padding(.horizontal, adaptyW(20))
                    .padding(.top, 16)
                }
            }
        }
        .onAppear {
            iap.fetchProducts()
        }
    }

    var topBar: some View {
        HStack {
            Spacer()
            Button { dismiss() } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 26))
                    .foregroundStyle(ColorSX.textMuted)
            }
        }
        .padding(.horizontal, adaptyW(20))
        .padding(.top, adaptyH(20))
    }

    var heroSection: some View {
        VStack(spacing: 14) {
            Image(systemName: "paintpalette.fill")
                .font(.system(size: 56))
                .foregroundStyle(GradientSX.gold)
                .glowEffect(ColorSX.accent, radius: 20)
            Text("App Appearance")
                .font(FontSX.display(26))
                .foregroundStyle(GradientSX.goldText)
                .multilineTextAlignment(.center)
            Text("Personalize your Speed Rodeo SX experience with exclusive visual themes.")
                .font(FontSX.body(15))
                .foregroundStyle(ColorSX.textSecondary)
                .multilineTextAlignment(.center)
        }
    }

    var offersSection: some View {
        VStack(spacing: 14) {
            ForEach(offerings, id: \.id) { offer in
                let isOwned = offer.id == "classic" || iap.isPurchased(offer.id)
                let isActive = themeManager.currentTheme == offer.theme
                
                VStack(spacing: 0) {
                    HStack(spacing: 14) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(offer.gradient)
                            .frame(width: adaptyW(50), height: adaptyH(40))
                            .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(offer.color.opacity(0.5), lineWidth: 1))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(offer.title)
                                .font(FontSX.headline(16))
                                .foregroundStyle(ColorSX.textPrimary)
                            Text(offer.subtitle)
                                .font(FontSX.body(12))
                                .foregroundStyle(ColorSX.textMuted)
                        }
                        
                        Spacer()
                        
                        if isActive {
                            Text("Active")
                                .font(FontSX.label(13))
                                .foregroundStyle(ColorSX.positive)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(ColorSX.positive.opacity(0.1))
                                .clipShape(Capsule())
                        } else if isOwned {
                            Button {
                                withAnimation {
                                    themeManager.currentTheme = offer.theme
                                }
                            } label: {
                                Text("Select")
                                    .font(FontSX.label(13))
                                    .foregroundStyle(ColorSX.accent)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(ColorSX.accent.opacity(0.1))
                                    .clipShape(Capsule())
                            }
                        } else {
                            PremiumBadgeSX()
                        }
                    }
                    .padding(16)
                    
                    if !isOwned {
                        let product = iap.products.first { $0.productIdentifier == offer.id }
                        Button {
                            if let p = product { iap.purchase(p) }
                            else { iap.fetchProducts() }
                        } label: {
                            HStack {
                                Text("Unlock for \(product?.localizedPriceVE ?? "$1.99")")
                                Spacer()
                                Image(systemName: "lock.fill")
                            }
                            .font(FontSX.label(15))
                            .foregroundStyle(.black)
                            .padding(14)
                            .background(GradientSX.gold)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 14)
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(GradientSX.card)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .strokeBorder(isActive ? offer.color : offer.color.opacity(0.2), lineWidth: isActive ? 2 : 1)
                        )
                )
                .scaleEffect(isActive ? 1.02 : 1.0)
            }
        }
    }

    var restoreButton: some View {
        Button { iap.restorePurchases() } label: {
            Text("Restore Purchases")
                .font(FontSX.label(15))
                .foregroundStyle(ColorSX.accent)
                .frame(maxWidth: .infinity)
                .frame(height: adaptyH(50))
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(ColorSX.surface)
                        .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(ColorSX.accent.opacity(0.3), lineWidth: 1))
                )
        }
    }

    var footerText: some View {
        Text("Payment will be charged to your Apple ID account. Themes are one-time purchases and require no subscription.")
            .font(FontSX.body(11))
            .foregroundStyle(ColorSX.textMuted)
            .multilineTextAlignment(.center)
    }
}

#Preview {
    PaywallViewSX()
        .environment(MainViewModelSX())
        .environment(IAPManagerVE.shared)
}
