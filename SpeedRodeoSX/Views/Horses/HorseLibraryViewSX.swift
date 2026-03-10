import SwiftUI

struct HorseLibraryViewSX: View {
    @Environment(MainViewModelSX.self) private var viewModel
    @State private var selectedHorse: HorseBreedModelSX? = nil
    @State private var sortBy: String = "Speed"
    @Environment(\.dismiss) private var dismiss

    var sorted: [HorseBreedModelSX] {
        switch sortBy {
        case "Speed": return viewModel.horseBreeds.sorted { $0.speedRating > $1.speedRating }
        case "Endurance": return viewModel.horseBreeds.sorted { $0.enduranceRating > $1.enduranceRating }
        case "Racing": return viewModel.horseBreeds.sorted { $0.racingSuitability > $1.racingSuitability }
        default: return viewModel.horseBreeds.sorted { $0.name < $1.name }
        }
    }

    var body: some View {
        ZStack {
            AnimatedBackgroundSX()
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
                    Section {
                        LazyVStack(spacing: 14) {
                            ForEach(sorted) { horse in
                                Button { selectedHorse = horse } label: {
                                    HorseCardRowSX(horse: horse)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 10)
                        Spacer().frame(height: adaptyH(100))
                    } header: {
                        VStack(spacing: 0) {
                            Spacer().frame(height: 50)
                            HStack {
                                Button { dismiss() } label: {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundStyle(ColorSX.textPrimary)
                                        .frame(width: 38, height: 38)
                                        .background(Circle().fill(ColorSX.surfaceElevated))
                                }
                                .padding(.leading, 16)
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("Horse")
                                        .font(FontSX.display(24))
                                        .foregroundStyle(GradientSX.goldText)
                                    Text("Encyclopedia")
                                        .font(FontSX.display(24))
                                        .foregroundStyle(GradientSX.goldText)
                                }
                                .padding(.leading, 8)
                                
                                Spacer()
                                HorseOutlineSX()
                                    .fill(GradientSX.gold)
                                    .frame(width: adaptyW(44), height: adaptyH(44))
                                    .glowEffect(ColorSX.accentGold, radius: 10)
                                    .padding(.trailing, 16)
                            }
                            .padding(.vertical, 12)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(["Speed", "Endurance", "Racing", "Name"], id: \.self) { sort in
                                        Button {
                                            withAnimation { sortBy = sort }
                                        } label: {
                                            Text("By \(sort)")
                                                .font(FontSX.label(13))
                                                .padding(.horizontal, 14)
                                                .padding(.vertical, 8)
                                                .background(Capsule().fill(sortBy == sort ? ColorSX.accent : ColorSX.surface))
                                                .foregroundStyle(sortBy == sort ? .black : ColorSX.textSecondary)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.bottom, 12)
                            }
                        }
                        .background(.ultraThinMaterial)
                    }
                }
            }
            .ignoresSafeArea(edges: .top)
        }
        .navigationBarHidden(true)
        .navigationDestination(item: $selectedHorse) { horse in
            HorseDetailViewSX(horse: horse)
        }
    }
}

struct HorseCardRowSX: View {
    let horse: HorseBreedModelSX

    var body: some View {
        GlowingCardSX(glowColor: ColorSX.accentGold, padding: 16) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(horse.name)
                            .font(FontSX.headline(17))
                            .foregroundStyle(ColorSX.textPrimary)
                        HStack(spacing: 6) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 11))
                                .foregroundStyle(ColorSX.textMuted)
                            Text(horse.origin)
                                .font(FontSX.caption(12))
                                .foregroundStyle(ColorSX.textMuted)
                            Text("•")
                                .foregroundStyle(ColorSX.textMuted)
                            Text(horse.height)
                                .font(FontSX.caption(12))
                                .foregroundStyle(ColorSX.textMuted)
                        }
                    }
                    Spacer()
                    ZStack {
                        Circle().fill(ColorSX.accentGold.opacity(0.18)).frame(width: adaptyW(48), height: adaptyH(48))
                        HorseOutlineSX()
                            .fill(GradientSX.gold)
                            .frame(width: adaptyW(30), height: adaptyH(30))
                    }
                }
                HStack(spacing: 16) {
                    miniStat(label: "Speed", value: horse.speedRating, color: ColorSX.danger)
                    miniStat(label: "Endurance", value: horse.enduranceRating, color: ColorSX.positive)
                    miniStat(label: "Racing", value: horse.racingSuitability, color: ColorSX.glowBlue)
                }
                Text(horse.summary)
                    .font(FontSX.body(12))
                    .foregroundStyle(ColorSX.textMuted)
                    .lineLimit(2)
            }
        }
    }

    func miniStat(label: String, value: Int, color: Color) -> some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(FontSX.headline(16))
                .foregroundStyle(color)
            Text(label)
                .font(.system(size: 10, weight: .medium, design: .rounded))
                .foregroundStyle(ColorSX.textMuted)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    HorseLibraryViewSX().environment(MainViewModelSX())
}
