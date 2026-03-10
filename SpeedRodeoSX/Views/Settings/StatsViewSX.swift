import SwiftUI
import Charts
import SwiftData

struct StatsViewSX: View {
    @Query private var completedTasks: [CompletedTaskSX]
    @Query private var sessions: [TrainingSessionSX]
    @Query private var favorites: [FavoriteItemSX]

    var body: some View {
        ZStack {
            AnimatedBackgroundSX()
            ScrollView(showsIndicators: false) {
                VStack(spacing: adaptyH(22)) {
                    headerSection
                    overallStatsGrid
                    if !completedTasks.isEmpty { taskScoreChart }
                    if !sessions.isEmpty { sessionChart }
                    if completedTasks.isEmpty && sessions.isEmpty { emptyState }
                    Spacer().frame(height: adaptyH(100))
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
        }
        .navigationTitle("Statistics")
        .navigationBarTitleDisplayMode(.inline)
    }

    var headerSection: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Statistics")
                    .font(FontSX.display(30))
                    .foregroundStyle(GradientSX.goldText)
                Text("Your training analytics")
                    .font(FontSX.body(13))
                    .foregroundStyle(ColorSX.textMuted)
            }
            Spacer()
            Image(systemName: "chart.bar.fill")
                .font(.system(size: 28))
                .foregroundStyle(GradientSX.gold)
        }
    }

    var overallStatsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
            statCell(value: "\(completedTasks.count)", label: "Tasks Completed", icon: "checkmark.circle.fill", color: ColorSX.positive)
            let avg = completedTasks.isEmpty ? 0 : completedTasks.map(\.score).reduce(0, +) / completedTasks.count
            statCell(value: "\(avg)%", label: "Avg Task Score", icon: "star.fill", color: ColorSX.accentGold)
            statCell(value: "\(sessions.count)", label: "Simulator Runs", icon: "speedometer", color: ColorSX.glowBlue)
            statCell(value: "\(favorites.count)", label: "Saved Items", icon: "heart.fill", color: ColorSX.danger)
        }
    }

    func statCell(value: String, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon).font(.system(size: 22)).foregroundStyle(color)
            Text(value).font(FontSX.display(28)).foregroundStyle(color)
            Text(label).font(FontSX.caption(11)).foregroundStyle(ColorSX.textMuted).multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(GradientSX.card)
                .overlay(RoundedRectangle(cornerRadius: 18).strokeBorder(color.opacity(0.25), lineWidth: 1))
        )
    }

    var taskScoreChart: some View {
        GlowingCardSX(glowColor: ColorSX.glowBlue) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "chart.line.uptrend.xyaxis").foregroundStyle(ColorSX.glowBlue)
                    Text("Task Score History").font(FontSX.label(14)).foregroundStyle(ColorSX.textPrimary)
                }
                Chart {
                    ForEach(Array(completedTasks.suffix(8).enumerated()), id: \.offset) { i, task in
                        BarMark(
                            x: .value("Task", i + 1),
                            y: .value("Score", task.score)
                        )
                        .foregroundStyle(
                            LinearGradient(colors: [ColorSX.accent, ColorSX.accentGold], startPoint: .bottom, endPoint: .top)
                        )
                        .cornerRadius(4)
                    }
                }
                .frame(height: adaptyH(150))
                .chartYAxis {
                    AxisMarks(values: [0, 50, 100]) { val in
                        AxisGridLine().foregroundStyle(ColorSX.separator)
                        AxisValueLabel().foregroundStyle(ColorSX.textMuted)
                    }
                }
                .chartXAxis {
                    AxisMarks { AxisValueLabel().foregroundStyle(ColorSX.textMuted) }
                }
            }
        }
    }

    var sessionChart: some View {
        GlowingCardSX(glowColor: ColorSX.positive) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "speedometer").foregroundStyle(ColorSX.positive)
                    Text("Simulator Effectiveness").font(FontSX.label(14)).foregroundStyle(ColorSX.textPrimary)
                }
                Chart {
                    ForEach(Array(sessions.suffix(8).enumerated()), id: \.offset) { i, s in
                        LineMark(
                            x: .value("Session", i + 1),
                            y: .value("Score", s.effectivenessScore)
                        )
                        .foregroundStyle(ColorSX.positive)
                        .symbol(Circle())
                        AreaMark(
                            x: .value("Session", i + 1),
                            y: .value("Score", s.effectivenessScore)
                        )
                        .foregroundStyle(ColorSX.positive.opacity(0.15))
                    }
                }
                .frame(height: adaptyH(150))
                .chartYScale(domain: 0...100)
                .chartYAxis {
                    AxisMarks(values: [0, 50, 100]) { _ in
                        AxisGridLine().foregroundStyle(ColorSX.separator)
                        AxisValueLabel().foregroundStyle(ColorSX.textMuted)
                    }
                }
            }
        }
    }

    var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.bar")
                .font(.system(size: 48))
                .foregroundStyle(ColorSX.textMuted)
            Text("No data yet")
                .font(FontSX.headline(20))
                .foregroundStyle(ColorSX.textSecondary)
            Text("Complete training tasks and run simulations to see your analytics here.")
                .font(FontSX.body(14))
                .foregroundStyle(ColorSX.textMuted)
                .multilineTextAlignment(.center)
        }
        .padding(adaptyW(40))
    }
}

#Preview {
    StatsViewSX()
        .modelContainer(for: [CompletedTaskSX.self, TrainingSessionSX.self, FavoriteItemSX.self], inMemory: true)
}
