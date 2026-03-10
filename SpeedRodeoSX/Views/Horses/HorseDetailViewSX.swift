import SwiftUI

struct HorseDetailViewSX: View {
    let horse: HorseBreedModelSX
    @State private var selectedTab: String = "Overview"
    let tabs = ["Overview", "History", "Training", "Racing"]

    var body: some View {
        ZStack {
            AnimatedBackgroundSX()
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
                    Section {
                        VStack(spacing: 20) {
                            heroStats
                            tabContent
                            Spacer().frame(height: adaptyH(100))
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 14)
                    } header: {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(tabs, id: \.self) { t in
                                    Button {
                                        withAnimation { selectedTab = t }
                                    } label: {
                                        Text(t)
                                            .font(FontSX.label(13))
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(Capsule().fill(selectedTab == t ? ColorSX.accent : ColorSX.surface))
                                            .foregroundStyle(selectedTab == t ? .black : ColorSX.textSecondary)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                        }
                        .background(.ultraThinMaterial)
                    }
                }
            }
        }
        .navigationTitle(horse.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    var heroStats: some View {
        GlowingCardSX(glowColor: ColorSX.accentGold) {
            VStack(spacing: 16) {
                HStack {
                    ZStack {
                        Circle().fill(ColorSX.accentGold.opacity(0.18)).frame(width: adaptyW(70), height: adaptyH(70))
                        HorseOutlineSX().fill(GradientSX.gold).frame(width: adaptyW(44), height: adaptyH(44))
                            .glowEffect(ColorSX.accentGold, radius: 10)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text(horse.name)
                            .font(FontSX.headline(20))
                            .foregroundStyle(ColorSX.textPrimary)
                        Text("Origin: \(horse.origin)")
                            .font(FontSX.body(13))
                            .foregroundStyle(ColorSX.textMuted)
                        Text("\(horse.height) • \(horse.weight)")
                            .font(FontSX.caption(12))
                            .foregroundStyle(ColorSX.textMuted)
                    }
                    Spacer()
                }
                Divider().background(ColorSX.separator)
                VStack(spacing: 10) {
                    HorseStatBarSX(label: "Speed", value: horse.speedRating, max: 100, color: ColorSX.danger)
                    HorseStatBarSX(label: "Endurance", value: horse.enduranceRating, max: 100, color: ColorSX.positive)
                    HorseStatBarSX(label: "Temperament", value: horse.temperamentRating, max: 100, color: ColorSX.glowBlue)
                    HorseStatBarSX(label: "Racing Suitability", value: horse.racingSuitability, max: 100, color: ColorSX.accentGold)
                }
            }
        }
    }

    @ViewBuilder
    var tabContent: some View {
        switch selectedTab {
        case "Overview":
            textCard(title: "Summary", body: horse.summary, icon: "hare.fill", color: ColorSX.accentGold)
            textCard(title: "Physical Traits", body: horse.physicalTraits, icon: "figure.walk", color: ColorSX.glowBlue)
        case "History":
            textCard(title: "History & Origins", body: horse.history, icon: "clock.fill", color: ColorSX.glowPurple)
        case "Training":
            textCard(title: "Training Requirements", body: horse.trainingRequirements, icon: "dumbbell.fill", color: ColorSX.glowOrange)
        case "Racing":
            textCard(title: "Racing Potential", body: horse.racingPotential, icon: "flag.checkered", color: ColorSX.danger)
        default:
            EmptyView()
        }
    }

    func textCard(title: String, body: String, icon: String, color: Color) -> some View {
        GlowingCardSX(glowColor: color) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: icon).foregroundStyle(color).font(.system(size: 16))
                    Text(title).font(FontSX.label(15)).foregroundStyle(ColorSX.textPrimary)
                }
                Text(body)
                    .font(FontSX.body(14))
                    .foregroundStyle(ColorSX.textSecondary)
                    .lineSpacing(5)
            }
        }
    }
}

#Preview {
    NavigationStack {
        HorseDetailViewSX(horse: HorseBreedModelSX(
            id: "h1", name: "Thoroughbred", origin: "England",
            height: "16.0 hh", weight: "500 kg",
            speedRating: 98, enduranceRating: 72, temperamentRating: 65, racingSuitability: 100,
            summary: "The world's greatest racing breed.",
            history: "Developed in England...", physicalTraits: "Lean and refined...",
            trainingRequirements: "Interval training...", racingPotential: "Dominant across flat racing.",
            imageName: "thoroughbred_gallop"
        ))
    }
}
