import SwiftUI

struct AboutViewSX: View {
    var body: some View {
        ZStack {
            AnimatedBackgroundSX()
            ScrollView(showsIndicators: false) {
                VStack(spacing: adaptyH(22)) {
                    heroSection
                    versionCard
                    featuresCard
                    creditsCard
                    Spacer().frame(height: adaptyH(100))
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }

    var heroSection: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(ColorSX.accentGold.opacity(0.15))
                    .frame(width: adaptyW(100), height: adaptyH(100))
                    .shadow(color: ColorSX.accentGold.opacity(0.3), radius: 20)
                HorseOutlineSX()
                    .fill(GradientSX.gold)
                    .frame(width: adaptyW(60), height: adaptyH(60))
                    .glowEffect(ColorSX.accentGold, radius: 12)
            }
            Text("Speed Rodeo SX")
                .font(FontSX.display(28))
                .foregroundStyle(GradientSX.goldText)
            Text("Premium Equestrian Simulator")
                .font(FontSX.body(15))
                .foregroundStyle(ColorSX.textMuted)
        }
        .padding(.top, 10)
    }

    var versionCard: some View {
        GlowingCardSX(glowColor: ColorSX.accentGold) {
            VStack(spacing: 12) {
                infoRow("Version", value: "1.0.0")
                Divider().background(ColorSX.separator)
                infoRow("Platform", value: "iOS 17+")
            }
        }
    }

    func infoRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label).font(FontSX.body(14)).foregroundStyle(ColorSX.textMuted)
            Spacer()
            Text(value).font(FontSX.label(14)).foregroundStyle(ColorSX.textPrimary)
        }
    }

    var featuresCard: some View {
        GlowingCardSX(glowColor: ColorSX.glowBlue) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "star.fill").foregroundStyle(ColorSX.accentGold)
                    Text("Key Features").font(FontSX.label(15)).foregroundStyle(ColorSX.textPrimary)
                }
                featureRow("20 Expert Equestrian Articles", icon: "newspaper.fill")
                featureRow("10 Interactive Training Tasks", icon: "figure.equestrian.sports")
                featureRow("Horse Breed Encyclopedia", icon: "hare.fill")
                featureRow("Training & Nutrition Simulators", icon: "speedometer")
                featureRow("Race Strategy Laboratory", icon: "flag.checkered")
                featureRow("Swift Charts Analytics", icon: "chart.bar.fill")
                featureRow("Premium Unlock Themes via IAP", icon: "paintpalette.fill")
                featureRow("100% Offline — No Internet Required", icon: "wifi.slash")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    func featureRow(_ text: String, icon: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundStyle(ColorSX.glowBlue)
                .frame(width: 20)
            Text(text)
                .font(FontSX.body(14))
                .foregroundStyle(ColorSX.textSecondary)
        }
    }

    var creditsCard: some View {
        GlowingCardSX(glowColor: ColorSX.glowPurple) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "heart.fill").foregroundStyle(ColorSX.danger)
                    Text("Made with Passion").font(FontSX.label(15)).foregroundStyle(ColorSX.textPrimary)
                }
                Text("Speed Rodeo SX was built by an independent developer passionate about equestrian sport and educational technology. Every article, task, and simulation has been designed to provide genuine value to riders aspiring to compete at higher levels.")
                    .font(FontSX.body(13))
                    .foregroundStyle(ColorSX.textSecondary)
                    .lineSpacing(4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    NavigationStack { AboutViewSX() }
}
