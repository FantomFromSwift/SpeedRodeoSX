import SwiftUI

struct JournalViewSX: View {
    @Environment(MainViewModelSX.self) private var viewModel
    @State private var showArticles = false
    @State private var showTasks = false
    @State private var showHorseLibrary = false
    @State private var showSimulator = false
    @State private var showNutrition = false
    @State private var showRaceLab = false

    var body: some View {
        NavigationStack {
            ZStack {
                AnimatedBackgroundSX()
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: adaptyH(20)) {
                        pinnedHeader
                        journalGrid
                        Spacer().frame(height: adaptyH(100))
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
            }
            .navigationDestination(isPresented: $showArticles) {
                ArticlesViewSX().environment(viewModel)
            }
            .navigationDestination(isPresented: $showTasks) {
                TasksListViewSX().environment(viewModel)
            }
            .navigationDestination(isPresented: $showHorseLibrary) {
                HorseLibraryViewSX().environment(viewModel)
            }
            .navigationDestination(isPresented: $showSimulator) {
                TrainingSimulatorViewSX().environment(viewModel)
            }
            .navigationDestination(isPresented: $showNutrition) {
                NutritionPlannerViewSX().environment(viewModel)
            }
            .navigationDestination(isPresented: $showRaceLab) {
                RaceStrategyLabViewSX().environment(viewModel)
            }
        }
    }

    var pinnedHeader: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Journal")
                    .font(FontSX.display(30))
                    .foregroundStyle(GradientSX.goldText)
                Text("Your equestrian knowledge hub")
                    .font(FontSX.body(14))
                    .foregroundStyle(ColorSX.textMuted)
            }
            Spacer()
            Image(systemName: "book.fill")
                .font(.system(size: 26))
                .foregroundStyle(GradientSX.gold)
        }
        .padding(.top, 12)
    }

    var journalGrid: some View {
        VStack(spacing: 14) {
            HStack(spacing: 14) {
                journalCard(icon: "newspaper.fill", title: "Articles", subtitle: "\(viewModel.articles.count) educational articles", color: ColorSX.glowBlue) {
                    showArticles = true
                }
                journalCard(icon: "figure.equestrian.sports", title: "Training Tasks", subtitle: "10 progressive challenges", color: ColorSX.glowOrange) {
                    showTasks = true
                }
            }
            HStack(spacing: 14) {
                journalCard(icon: "hare.fill", title: "Horse Encyclopedia", subtitle: "10 detailed breeds", color: ColorSX.accentGold) {
                    showHorseLibrary = true
                }
                journalCard(icon: "speedometer", title: "Training Simulator", subtitle: "Optimize your sessions", color: ColorSX.positive) {
                    showSimulator = true
                }
            }
            HStack(spacing: 14) {
                journalCard(icon: "leaf.fill", title: "Nutrition Planner", subtitle: "Build optimal diet plans", color: ColorSX.glowPurple) {
                    showNutrition = true
                }
                journalCard(icon: "flag.checkered.2.crossed", title: "Race Strategy Lab", subtitle: "Design winning strategies", color: ColorSX.danger) {
                    showRaceLab = true
                }
            }
        }
    }

    func journalCard(icon: String, title: String, subtitle: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color.opacity(0.18))
                        .frame(width: adaptyW(48), height: adaptyH(48))
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundStyle(color)
                        .glowEffect(color, radius: 8)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(FontSX.headline(15))
                        .foregroundStyle(ColorSX.textPrimary)
                    Text(subtitle)
                        .font(FontSX.body(12))
                        .foregroundStyle(ColorSX.textMuted)
                        .lineLimit(2)
                }
                Image(systemName: "arrow.right")
                    .font(.system(size: 12))
                    .foregroundStyle(color.opacity(0.7))
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(GradientSX.card)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .strokeBorder(color.opacity(0.25), lineWidth: 1)
                    )
            )
            .shadow(color: color.opacity(0.12), radius: 10, y: 4)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    JournalViewSX()
        .environment(MainViewModelSX())
}
