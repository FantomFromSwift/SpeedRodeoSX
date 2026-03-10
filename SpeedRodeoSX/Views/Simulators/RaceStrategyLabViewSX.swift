import SwiftUI

struct RaceStrategyLabViewSX: View {
    @Environment(MainViewModelSX.self) private var viewModel

    var body: some View {
        ZStack {
            AnimatedBackgroundSX()
            ScrollView(showsIndicators: false) {
                VStack(spacing: adaptyH(22)) {
                    heroHeader
                    startPaceSection
                    midPacingSection
                    finalSprintSection
                    buildButton
                    if let pred = viewModel.racePrediction {
                        predictionCard(pred: pred)
                    }
                    strategyInfoCard
                    Spacer().frame(height: adaptyH(100))
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
            }
        }
        .navigationTitle("Race Strategy Lab")
        .navigationBarTitleDisplayMode(.inline)
    }

    var heroHeader: some View {
        GlowingCardSX(glowColor: ColorSX.danger) {
            HStack(spacing: 14) {
                Image(systemName: "flag.checkered.2.crossed")
                    .font(.system(size: 28))
                    .foregroundStyle(ColorSX.danger)
                    .glowEffect(ColorSX.danger, radius: 10)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Race Strategy Lab")
                        .font(FontSX.headline(18))
                        .foregroundStyle(ColorSX.textPrimary)
                    Text("Configure your start, mid-race, and sprint timing to optimize predicted performance.")
                        .font(FontSX.body(12))
                        .foregroundStyle(ColorSX.textMuted)
                }
            }
        }
    }

    var startPaceSection: some View {
        paceCard(
            title: "Start Pace",
            icon: "bolt.fill",
            color: ColorSX.glowOrange,
            value: Bindable(viewModel).raceStartPace,
            description: "Early pace aggressiveness. High values risk energy depletion before final stretch.",
            low: "Conservative", high: "Aggressive"
        )
    }

    var midPacingSection: some View {
        paceCard(
            title: "Mid Race Pacing",
            icon: "gauge.medium",
            color: ColorSX.glowBlue,
            value: Bindable(viewModel).raceMidPacing,
            description: "Middle distance energy management. Balanced pacing here is critical for late energy reserves.",
            low: "Hold Back", high: "Press On"
        )
    }

    var finalSprintSection: some View {
        paceCard(
            title: "Final Sprint Timing",
            icon: "flame.fill",
            color: ColorSX.danger,
            value: Bindable(viewModel).raceFinalSprint,
            description: "Commitment level entering the home straight. Maximum value only sustainable if well reserved.",
            low: "Late Kick", high: "Full Sprint"
        )
    }

    func paceCard(title: String, icon: String, color: Color, value: Binding<Double>, description: String, low: String, high: String) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: icon).forecStyle(color).font(.system(size: 14))
                Text(title).font(FontSX.label(14)).foregroundStyle(ColorSX.textPrimary)
                Spacer()
                Text("\(Int(value.wrappedValue * 100))%")
                    .font(FontSX.label(13))
                    .foregroundStyle(color)
            }
            Slider(value: value, in: 0.0...1.0).tint(color)
            HStack {
                Text(low).font(FontSX.caption(11)).foregroundStyle(ColorSX.textMuted)
                Spacer()
                Text(high).font(FontSX.caption(11)).foregroundStyle(ColorSX.textMuted)
            }
            Text(description)
                .font(FontSX.body(12))
                .foregroundStyle(ColorSX.textMuted)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(GradientSX.card)
                .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(color.opacity(0.2), lineWidth: 1))
        )
    }

    var buildButton: some View {
        Button { withAnimation { viewModel.buildRaceStrategy() } } label: {
            HStack {
                Image(systemName: "flag.checkered")
                Text("Predict Race Outcome")
            }
            .font(FontSX.label(17))
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .frame(height: adaptyH(54))
            .background(GradientSX.gold)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: ColorSX.accentGold.opacity(0.4), radius: 12, y: 4)
        }
    }

    func predictionCard(pred: RacePredictionSX) -> some View {
        let color = pred.score > 75 ? ColorSX.positive : pred.score > 55 ? ColorSX.warning : ColorSX.danger
        return GlowingCardSX(glowColor: color) {
            VStack(spacing: 16) {
                Text("Race Prediction")
                    .font(FontSX.label(14))
                    .foregroundStyle(ColorSX.textMuted)
                Text(pred.label)
                    .font(FontSX.headline(20))
                    .foregroundStyle(color)
                    .multilineTextAlignment(.center)
                HorseStatBarSX(label: "Predicted Score", value: Int(pred.score), max: 100, color: color)
                HorseStatBarSX(label: "Energy Reserve", value: Int(pred.energyReserve), max: 100, color: ColorSX.glowBlue)
            }
        }
    }

    var strategyInfoCard: some View {
        GlowingCardSX(glowColor: ColorSX.glowPurple) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "info.circle.fill").foregroundStyle(ColorSX.glowPurple)
                    Text("Strategy Principles").font(FontSX.label(14)).foregroundStyle(ColorSX.textPrimary)
                }
                VStack(alignment: .leading, spacing: 8) {
                    infoRow("Front runners should hold start at 60–70% to avoid energy collapse")
                    infoRow("Stalkers benefit from 50–65% start to maintain positional contact")
                    infoRow("Closers conserve most energy but require fast pace from rivals to succeed")
                    infoRow("Final sprint at 100% only sustainable with minimum 25% energy reserve")
                }
            }
        }
    }

    func infoRow(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Circle().fill(ColorSX.glowPurple).frame(width: 5, height: 5).padding(.top, 5)
            Text(text).font(FontSX.body(12)).foregroundStyle(ColorSX.textSecondary)
        }
    }
}

extension View {
    func forecStyle(_ color: Color) -> some View {
        self.foregroundStyle(color)
    }
}

#Preview {
    NavigationStack {
        RaceStrategyLabViewSX().environment(MainViewModelSX())
    }
}
