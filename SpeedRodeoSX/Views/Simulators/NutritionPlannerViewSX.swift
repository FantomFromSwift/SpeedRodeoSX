import SwiftUI

struct NutritionPlannerViewSX: View {
    @Environment(MainViewModelSX.self) private var viewModel

    var body: some View {
        ZStack {
            AnimatedBackgroundSX()
            ScrollView(showsIndicators: false) {
                VStack(spacing: adaptyH(22)) {
                    heroHeader
                    grainSlider
                    haySlider
                    supplementsSlider
                    evaluateButton
                    if let result = viewModel.nutritionResult {
                        resultSection(result: result)
                    }
                    guidanceSection
                    Spacer().frame(height: adaptyH(100))
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
            }
        }
        .navigationTitle("Nutrition Planner")
        .navigationBarTitleDisplayMode(.inline)
    }

    var heroHeader: some View {
        GlowingCardSX(glowColor: ColorSX.positive) {
            HStack(spacing: 14) {
                Image(systemName: "leaf.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(ColorSX.positive)
                    .glowEffect(ColorSX.positive, radius: 10)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Diet Simulator")
                        .font(FontSX.headline(18))
                        .foregroundStyle(ColorSX.textPrimary)
                    Text("Build a custom diet plan and evaluate its effect on energy, muscle growth, and recovery.")
                        .font(FontSX.body(12))
                        .foregroundStyle(ColorSX.textMuted)
                }
            }
        }
    }

    var grainSlider: some View {
        nutritionSlider(
            title: "Grain & Concentrates",
            icon: "circle.grid.3x3.fill",
            value: Bindable(viewModel).nutritionGrain,
            color: ColorSX.warning,
            description: "Oats, barley, and performance feeds providing fast-burning energy."
        )
    }

    var haySlider: some View {
        nutritionSlider(
            title: "Forage & Hay",
            icon: "leaf.fill",
            value: Bindable(viewModel).nutritionHay,
            color: ColorSX.positive,
            description: "Timothy and grass hay providing structural fiber and gut health support."
        )
    }

    var supplementsSlider: some View {
        nutritionSlider(
            title: "Supplements & Oils",
            icon: "drop.fill",
            value: Bindable(viewModel).nutritionSupplements,
            color: ColorSX.glowBlue,
            description: "Vitamins, electrolytes, and fat supplements for recovery and performance."
        )
    }

    func nutritionSlider(title: String, icon: String, value: Binding<Double>, color: Color, description: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon).font(.system(size: 14)).foregroundStyle(color)
                Text(title).font(FontSX.label(14)).foregroundStyle(ColorSX.textPrimary)
                Spacer()
                Text("\(Int(value.wrappedValue * 100))%")
                    .font(FontSX.label(13))
                    .foregroundStyle(color)
            }
            Slider(value: value, in: 0.0...1.0).tint(color)
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

    var evaluateButton: some View {
        Button { withAnimation { viewModel.evaluateNutrition() } } label: {
            HStack {
                Image(systemName: "chart.bar.fill")
                Text("Evaluate Diet Plan")
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

    func resultSection(result: NutritionResultSX) -> some View {
        GlowingCardSX(glowColor: ColorSX.positive) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Diet Evaluation")
                    .font(FontSX.label(15))
                    .foregroundStyle(ColorSX.textPrimary)
                HorseStatBarSX(label: "Energy Output", value: Int(result.energy), max: 100, color: ColorSX.warning)
                HorseStatBarSX(label: "Muscle Growth Support", value: Int(result.muscle), max: 100, color: ColorSX.glowBlue)
                HorseStatBarSX(label: "Recovery Speed", value: Int(result.recovery), max: 100, color: ColorSX.positive)
                Text(dietAdvice(result: result))
                    .font(FontSX.body(13))
                    .foregroundStyle(ColorSX.textSecondary)
                    .lineSpacing(4)
            }
        }
    }

    func dietAdvice(result: NutritionResultSX) -> String {
        let avg = (result.energy + result.muscle + result.recovery) / 3
        if avg > 70 { return "Excellent balance. This diet supports peak competitive performance with strong energy, muscle repair, and recovery capacity." }
        if avg > 50 { return "Good foundation. Consider increasing supplement ratios to improve recovery speed for intensive training periods." }
        return "Imbalanced plan. Increase forage allocation first, then reassess grain and supplement ratios for optimal performance support."
    }

    var guidanceSection: some View {
        GlowingCardSX(glowColor: ColorSX.glowBlue) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "info.circle.fill").foregroundStyle(ColorSX.glowBlue)
                    Text("Feeding Guidelines").font(FontSX.label(14)).foregroundStyle(ColorSX.textPrimary)
                }
                VStack(alignment: .leading, spacing: 8) {
                    guideRow("Forage should constitute minimum 50% of total diet dry weight")
                    guideRow("Max concentrate per meal: 2.5 kg to prevent hindgut acidosis")
                    guideRow("Oil additions should be introduced gradually over 7–10 days")
                    guideRow("Electrolytes most effective 12–16h before hard training sessions")
                }
            }
        }
    }

    func guideRow(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Circle().fill(ColorSX.glowBlue).frame(width: 5, height: 5).padding(.top, 5)
            Text(text).font(FontSX.body(13)).foregroundStyle(ColorSX.textSecondary)
        }
    }
}

#Preview {
    NavigationStack {
        NutritionPlannerViewSX().environment(MainViewModelSX())
    }
}
