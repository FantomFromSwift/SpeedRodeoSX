import SwiftUI

struct TaskDetailsViewSX: View {
    @Environment(MainViewModelSX.self) private var viewModel
    let task: TrainingTaskModelSX
    @State private var startTraining = false

    var body: some View {
        ZStack {
            AnimatedBackgroundSX()
            ScrollView(showsIndicators: false) {
                VStack(spacing: adaptyH(24)) {
                    heroSection
                    overviewSection
                    stepsPreviewSection
                    startButton
                    Spacer().frame(height: adaptyH(100))
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
        }
        .navigationTitle(task.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $startTraining) {
            TaskStepFlowSX(task: task)
                .environment(viewModel)
        }
    }

    var heroSection: some View {
        GlowingCardSX(glowColor: ColorSX.accentGold) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(ColorSX.accentGold.opacity(0.18))
                        .frame(width: adaptyW(70), height: adaptyH(70))
                    Image(systemName: "figure.equestrian.sports")
                        .font(.system(size: 32))
                        .foregroundStyle(GradientSX.gold)
                        .glowEffect(ColorSX.accentGold, radius: 10)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text(task.title)
                        .font(FontSX.headline(18))
                        .foregroundStyle(ColorSX.textPrimary)
                    HStack(spacing: 10) {
                        DifficultyBadgeSX(difficulty: task.difficulty)
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.system(size: 11))
                            Text("\(task.durationMinutes) min")
                                .font(FontSX.caption(12))
                        }
                        .foregroundStyle(ColorSX.textMuted)
                    }
                }
            }
        }
    }

    var overviewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("About this task")
                .font(FontSX.label(14))
                .foregroundStyle(ColorSX.textMuted)
            Text(task.description)
                .font(FontSX.body(15))
                .foregroundStyle(ColorSX.textSecondary)
                .lineSpacing(5)
            HStack(spacing: 16) {
                infoChip(icon: "list.number", label: "\(task.steps.count) Steps")
                infoChip(icon: "star.fill", label: "\(task.rewardPoints) Points")
                infoChip(icon: "tag.fill", label: task.category)
            }
        }
    }

    func infoChip(icon: String, label: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundStyle(ColorSX.accent)
            Text(label)
                .font(FontSX.caption(12))
                .foregroundStyle(ColorSX.textSecondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(ColorSX.surface)
                .overlay(Capsule().strokeBorder(ColorSX.accent.opacity(0.2), lineWidth: 1))
        )
    }

    var stepsPreviewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Training Steps")
                .font(FontSX.label(14))
                .foregroundStyle(ColorSX.textMuted)
            ForEach(Array(task.steps.enumerated()), id: \.element.id) { i, step in
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(ColorSX.accent.opacity(0.18))
                            .frame(width: adaptyW(32), height: adaptyH(32))
                        Text("\(i + 1)")
                            .font(FontSX.label(13))
                            .foregroundStyle(ColorSX.accent)
                    }
                    VStack(alignment: .leading, spacing: 3) {
                        Text(step.title)
                            .font(FontSX.label(14))
                            .foregroundStyle(ColorSX.textPrimary)
                        if step.isQuiz {
                            Text("Includes quiz")
                                .font(FontSX.caption(11))
                                .foregroundStyle(ColorSX.accentGold)
                        }
                    }
                    Spacer()
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(ColorSX.surface)
                )
            }
        }
    }

    var startButton: some View {
        Button { startTraining = true } label: {
            HStack {
                Image(systemName: "play.fill")
                Text("Start Training")
            }
            .font(FontSX.label(17))
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .frame(height: adaptyH(56))
            .background(GradientSX.gold)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: ColorSX.accentGold.opacity(0.4), radius: 12, y: 4)
        }
    }
}

#Preview {
    NavigationStack {
        TaskDetailsViewSX(task: TrainingTaskModelSX(
            id: "t1", title: "Horse Warm-Up", difficulty: "Beginner",
            durationMinutes: 15, category: "Conditioning",
            description: "Master the warm-up protocol.", steps: [], rewardPoints: 100
        ))
        .environment(MainViewModelSX())
    }
}
