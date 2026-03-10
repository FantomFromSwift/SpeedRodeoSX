import SwiftUI
import SwiftData

struct HomeViewSX: View {
    @Environment(MainViewModelSX.self) private var viewModel
    @AppStorage("usernameSX") private var username: String = "Rider"
    @Query private var completedTasks: [CompletedTaskSX]
    @Query private var favorites: [FavoriteItemSX]
    @State private var glowPulse: Bool = false
    @State private var navigateToArticle: ArticleModelSX? = nil
    @State private var navigateToTask: TrainingTaskModelSX? = nil
    @State private var showTrainingSimulator: Bool = false
    @State private var showHorseLibrary: Bool = false
    @State private var showStats: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                AnimatedBackgroundSX()
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 20) {
                        headerSection
                        dailyInsightCard
                        quickActionsRow
                        horseSpotlightCard
                        racePreparationCard
                        weeklyChallenge
                        if let article = viewModel.articles.first {
                            recommendedArticleCard(article: article)
                        }
                        progressSummaryCard
                        Spacer().frame(height: 100)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
            }
            .navigationDestination(item: $navigateToArticle) { article in
                ArticleDetailViewSX(article: article)
            }
            .navigationDestination(item: $navigateToTask) { task in
                TaskDetailsViewSX(task: task)
                    .environment(viewModel)
            }
            .navigationDestination(isPresented: $showTrainingSimulator) {
                TrainingSimulatorViewSX()
                    .environment(viewModel)
            }
            .navigationDestination(isPresented: $showHorseLibrary) {
                HorseLibraryViewSX()
                    .environment(viewModel)
            }
            .navigationDestination(isPresented: $showStats) {
                StatsViewSX()
            }
        }
    }

    var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Welcome back,")
                    .font(FontSX.body(14))
                    .foregroundStyle(ColorSX.textMuted)
                Text(username.isEmpty ? "Rider" : username)
                    .font(FontSX.display(26))
                    .foregroundStyle(GradientSX.goldText)
            }
            Spacer()
            ZStack {
                Circle()
                    .fill(ColorSX.accent.opacity(glowPulse ? 0.25 : 0.12))
                    .frame(width: adaptyW(50), height: adaptyH(50))
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: glowPulse)
                Image(systemName: "trophy.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(GradientSX.gold)
            }
        }
        .padding(.top, 16)
        .onAppear { glowPulse = true }
    }

    var dailyInsightCard: some View {
        GlowingCardSX(glowColor: ColorSX.glowBlue) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .foregroundStyle(ColorSX.glowBlue)
                    Text("Daily Insight")
                        .font(FontSX.label(13))
                        .foregroundStyle(ColorSX.textMuted)
                }
                Text(viewModel.dailyInsight)
                    .font(FontSX.body(15))
                    .foregroundStyle(ColorSX.textPrimary)
                    .lineSpacing(4)
            }
            .frame(maxWidth: .infinity)
        }
    }

    var quickActionsRow: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Launch")
                .font(FontSX.label(14))
                .foregroundStyle(ColorSX.textMuted)
            HStack(spacing: 12) {
                quickActionBtn(icon: "figure.equestrian.sports", label: "Simulator", color: ColorSX.accent) {
                    showTrainingSimulator = true
                }
                quickActionBtn(icon: "book.closed.fill", label: "Breeds", color: ColorSX.glowPurple) {
                    showHorseLibrary = true
                }
                quickActionBtn(icon: "chart.bar.fill", label: "Stats", color: ColorSX.glowBlue) {
                    showStats = true
                }
                quickActionBtn(icon: "flame.fill", label: "Tasks", color: ColorSX.glowOrange) {
                    if let task = viewModel.trainingTasks.first {
                        navigateToTask = task
                    }
                }
            }
        }
    }

    func quickActionBtn(icon: String, label: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(color.opacity(0.18))
                        .frame(width: adaptyW(56), height: adaptyH(56))
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundStyle(color)
                        .glowEffect(color, radius: 8)
                }
                Text(label)
                    .font(FontSX.caption(11))
                    .foregroundStyle(ColorSX.textSecondary)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }

    var horseSpotlightCard: some View {
        GlowingCardSX(glowColor: ColorSX.accentGold) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(ColorSX.accentGold.opacity(0.15))
                        .frame(width: adaptyW(64), height: adaptyH(64))
                    HorseOutlineSX()
                        .fill(GradientSX.gold)
                        .frame(width: adaptyW(40), height: adaptyH(40))
                        .glowEffect(ColorSX.accentGold, radius: 10)
                }
                VStack(alignment: .leading, spacing: 6) {
                    Text("Horse Spotlight")
                        .font(FontSX.caption(12))
                        .foregroundStyle(ColorSX.textMuted)
                    Text("Thoroughbred")
                        .font(FontSX.headline(18))
                        .foregroundStyle(ColorSX.textPrimary)
                    HStack(spacing: 12) {
                        statPill("Speed", value: "98", color: ColorSX.danger)
                        statPill("Endurance", value: "72", color: ColorSX.positive)
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(ColorSX.textMuted)
            }
        }
    }

    func statPill(_ label: String, value: String, color: Color) -> some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 6, height: 6)
            Text("\(label) \(value)")
                .font(FontSX.caption(11))
                .foregroundStyle(ColorSX.textSecondary)
        }
    }

    var racePreparationCard: some View {
        GlowingCardSX(glowColor: ColorSX.glowOrange) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "flag.checkered")
                        .foregroundStyle(ColorSX.glowOrange)
                    Text("Race Preparation Tips")
                        .font(FontSX.label(14))
                        .foregroundStyle(ColorSX.textPrimary)
                    Spacer()
                }
                VStack(alignment: .leading, spacing: 8) {
                    tipRow(icon: "clock.fill", text: "Final workout 48h before race — light canter only")
                    tipRow(icon: "drop.fill", text: "Increase hydration 24h before competition")
                    tipRow(icon: "zzz", text: "Maintain normal feeding schedule night before")
                }
            }
        }
    }

    func tipRow(icon: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundStyle(ColorSX.glowOrange)
                .frame(width: 16)
            Text(text)
                .font(FontSX.body(13))
                .foregroundStyle(ColorSX.textSecondary)
        }
    }

    var weeklyChallenge: some View {
        GlowingCardSX(glowColor: ColorSX.glowPurple) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "bolt.fill")
                        .foregroundStyle(ColorSX.glowPurple)
                    Text("Weekly Challenge")
                        .font(FontSX.label(14))
                        .foregroundStyle(ColorSX.textPrimary)
                    Spacer()
                    PremiumBadgeSX()
                }
                Text(viewModel.weeklyChallenge.title)
                    .font(FontSX.headline(16))
                    .foregroundStyle(GradientSX.goldText)
                Text(viewModel.weeklyChallenge.description)
                    .font(FontSX.body(13))
                    .foregroundStyle(ColorSX.textSecondary)
                    .lineSpacing(3)
                HStack {
                    Text("Reward: \(viewModel.weeklyChallenge.reward)")
                        .font(FontSX.caption(12))
                        .foregroundStyle(ColorSX.accentGold)
                    Spacer()
                    Text("\(Int(viewModel.weeklyChallenge.progress * 100))%")
                        .font(FontSX.label(13))
                        .foregroundStyle(ColorSX.accent)
                }
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4).fill(ColorSX.separator).frame(height: 6)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(ColorSX.glowPurple)
                            .frame(width: geo.size.width * viewModel.weeklyChallenge.progress, height: 6)
                            .shadow(color: ColorSX.glowPurple.opacity(0.5), radius: 4)
                    }
                }
                .frame(height: 6)
            }
        }
    }

    func recommendedArticleCard(article: ArticleModelSX) -> some View {
        Button {
            navigateToArticle = article
        } label: {
            GlowingCardSX(glowColor: ColorSX.glowBlue) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "newspaper.fill")
                            .foregroundStyle(ColorSX.glowBlue)
                        Text("Recommended Read")
                            .font(FontSX.caption(12))
                            .foregroundStyle(ColorSX.textMuted)
                        Spacer()
                        Text("\(article.readingMinutes) min")
                            .font(FontSX.caption(11))
                            .foregroundStyle(ColorSX.textMuted)
                    }
                    Text(article.title)
                        .font(FontSX.headline(16))
                        .foregroundStyle(ColorSX.textPrimary)
                        .lineLimit(2)
                    Text(article.summary)
                        .font(FontSX.body(13))
                        .foregroundStyle(ColorSX.textSecondary)
                        .lineLimit(2)
                }
            }
        }
        .buttonStyle(.plain)
    }

    var progressSummaryCard: some View {
        GlowingCardSX(glowColor: ColorSX.positive) {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .foregroundStyle(ColorSX.positive)
                    Text("Your Progress")
                        .font(FontSX.label(14))
                        .foregroundStyle(ColorSX.textPrimary)
                }
                HStack(spacing: 0) {
                    progressStatColumn(value: "\(completedTasks.count)", label: "Tasks Done")
                    Divider().background(ColorSX.separator).frame(height: adaptyH(40))
                    progressStatColumn(value: "\(favorites.count)", label: "Saved Items")
                    Divider().background(ColorSX.separator).frame(height: adaptyH(40))
                    progressStatColumn(value: "0", label: "Day Streak")
                }
            }
        }
    }

    func progressStatColumn(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(FontSX.display(24))
                .foregroundStyle(GradientSX.goldText)
            Text(label)
                .font(FontSX.caption(11))
                .foregroundStyle(ColorSX.textMuted)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    HomeViewSX()
        .environment(MainViewModelSX())
        .modelContainer(for: [CompletedTaskSX.self, FavoriteItemSX.self], inMemory: true)
}
