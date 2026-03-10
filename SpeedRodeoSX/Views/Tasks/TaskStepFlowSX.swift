import SwiftUI
import SwiftData

struct TaskStepFlowSX: View {
    @Environment(MainViewModelSX.self) private var viewModel
    @Environment(\.modelContext) private var ctx
    @Environment(\.dismiss) private var dismiss
    let task: TrainingTaskModelSX
    @State private var currentStep: Int = 0
    @State private var selectedAnswer: Int? = nil
    @State private var answeredCorrectly: Bool? = nil
    @State private var stepScore: Int = 0
    @State private var showFinish: Bool = false
    @State private var cardOffset: CGFloat = 50
    @State private var cardOpacity: Double = 0

    var step: TaskStepModelSX { task.steps[currentStep] }
    var isLast: Bool { currentStep == task.steps.count - 1 }

    var body: some View {
        ZStack {
            AnimatedBackgroundSX()
            VStack(spacing: 0) {
                progressHeader
                ScrollView(showsIndicators: false) {
                    VStack(spacing: adaptyH(22)) {
                        stepCard
                        if step.isQuiz { quizSection }
                        tipCard
                        actionButton
                        Spacer().frame(height: adaptyH(100))
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
            }
        }
        .navigationTitle("Step \(currentStep + 1) of \(task.steps.count)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(ColorSX.textSecondary)
                }
            }
        }
        .navigationDestination(isPresented: $showFinish) {
            TaskFinishViewSX(task: task, score: stepScore)
                .environment(viewModel)
        }
        .onAppear { animateCard() }
    }

    var progressHeader: some View {
        VStack(spacing: 10) {
            TrainingProgressViewSX(currentStep: currentStep, totalSteps: task.steps.count)
            HStack {
                Text(task.title)
                    .font(FontSX.caption(13))
                    .foregroundStyle(ColorSX.textMuted)
                Spacer()
                Text("\(stepScore) pts")
                    .font(FontSX.label(13))
                    .foregroundStyle(ColorSX.accentGold)
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
    }

    var stepCard: some View {
        GlowingCardSX(glowColor: ColorSX.accent) {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    ZStack {
                        Circle().fill(ColorSX.accent.opacity(0.18)).frame(width: adaptyW(36), height: adaptyH(36))
                        Text("\(currentStep + 1)")
                            .font(FontSX.headline(16))
                            .foregroundStyle(ColorSX.accent)
                    }
                    Text(step.title)
                        .font(FontSX.headline(17))
                        .foregroundStyle(ColorSX.textPrimary)
                    Spacer()
                }
                Text(step.instruction)
                    .font(FontSX.body(15))
                    .foregroundStyle(ColorSX.textSecondary)
                    .lineSpacing(5)
            }
        }
        .opacity(cardOpacity)
        .offset(y: cardOffset)
    }

    var tipCard: some View {
        GlowingCardSX(glowColor: ColorSX.accentGold, padding: 14) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "lightbulb.fill")
                    .foregroundStyle(ColorSX.accentGold)
                    .font(.system(size: 18))
                Text(step.tip)
                    .font(FontSX.body(13))
                    .foregroundStyle(ColorSX.textSecondary)
                    .lineSpacing(4)
            }
        }
        .opacity(cardOpacity)
        .offset(y: cardOffset)
    }

    @ViewBuilder
    var quizSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(step.quizQuestion)
                .font(FontSX.label(15))
                .foregroundStyle(ColorSX.textPrimary)
                .lineSpacing(4)
            ForEach(Array(step.quizOptions.enumerated()), id: \.offset) { i, option in
                Button {
                    guard answeredCorrectly == nil else { return }
                    selectedAnswer = i
                    let correct = i == step.correctAnswer
                    answeredCorrectly = correct
                    if correct { stepScore += 20 }
                } label: {
                    HStack {
                        Text(option)
                            .font(FontSX.body(14))
                            .foregroundStyle(ColorSX.textPrimary)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        if let ans = answeredCorrectly, selectedAnswer == i {
                            Image(systemName: ans ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundStyle(ans ? ColorSX.positive : ColorSX.danger)
                        } else if let _ = answeredCorrectly, i == step.correctAnswer {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(ColorSX.positive)
                        }
                    }
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(quizOptionBg(i))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(quizOptionBorder(i), lineWidth: 1.5)
                            )
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .opacity(cardOpacity)
        .offset(y: cardOffset)
    }

    func quizOptionBg(_ i: Int) -> Color {
        guard let ans = answeredCorrectly else { return ColorSX.surface }
        if selectedAnswer == i { return ans ? ColorSX.positive.opacity(0.15) : ColorSX.danger.opacity(0.15) }
        if i == step.correctAnswer { return ColorSX.positive.opacity(0.12) }
        return ColorSX.surface
    }

    func quizOptionBorder(_ i: Int) -> Color {
        guard let ans = answeredCorrectly else { return ColorSX.separator }
        if selectedAnswer == i { return ans ? ColorSX.positive : ColorSX.danger }
        if i == step.correctAnswer { return ColorSX.positive.opacity(0.5) }
        return ColorSX.separator
    }

    var canAdvance: Bool {
        if step.isQuiz { return answeredCorrectly != nil }
        return true
    }

    var actionButton: some View {
        Button {
            if isLast { showFinish = true }
            else { goToNext() }
        } label: {
            HStack {
                Text(isLast ? "Finish" : "Next Step")
                Image(systemName: isLast ? "checkmark" : "arrow.right")
            }
            .font(FontSX.label(17))
            .foregroundStyle(canAdvance ? .black : ColorSX.textMuted)
            .frame(maxWidth: .infinity)
            .frame(height: adaptyH(54))
            .background(canAdvance ? GradientSX.gold : LinearGradient(colors: [ColorSX.surface], startPoint: .leading, endPoint: .trailing))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .disabled(!canAdvance)
    }

    func goToNext() {
        withAnimation(.easeIn(duration: 0.2)) {
            cardOpacity = 0
            cardOffset = -30
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            currentStep += 1
            selectedAnswer = nil
            answeredCorrectly = nil
            cardOffset = 50
            animateCard()
        }
    }

    func animateCard() {
        withAnimation(.spring(response: 0.4)) {
            cardOpacity = 1
            cardOffset = 0
        }
    }
}

#Preview {
    NavigationStack {
        TaskStepFlowSX(task: TrainingTaskModelSX(
            id: "t1", title: "Warm-Up", difficulty: "Beginner",
            durationMinutes: 15, category: "Conditioning",
            description: "Desc.", steps: [
                TaskStepModelSX(id: "s1", stepNumber: 1, title: "Walk Phase", instruction: "Walk for 5 min.",
                                tip: "Watch for stiffness.", isQuiz: true,
                                quizQuestion: "What is the minimum warm-up?",
                                quizOptions: ["1 min", "3 min", "5 min", "10 min"], correctAnswer: 2)
            ], rewardPoints: 100
        ))
        .environment(MainViewModelSX())
    }
    .modelContainer(for: CompletedTaskSX.self, inMemory: true)
}
