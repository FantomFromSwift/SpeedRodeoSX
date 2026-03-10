import SwiftUI
import SwiftData

struct TaskFinishViewSX: View {
    @Environment(MainViewModelSX.self) private var viewModel
    @Environment(\.modelContext) private var ctx
    @Environment(\.dismiss) private var dismiss
    let task: TrainingTaskModelSX
    let score: Int
    @State private var badgeScale: CGFloat = 0
    @State private var confettiVisible: Bool = false
    @State private var savedToStats: Bool = false
    
    var grade: String {
        switch score {
        case 100...: return "Perfect"
        case 80..<100: return "Excellent"
        case 60..<80: return "Good"
        default: return "Completed"
        }
    }
    
    var gradeColor: Color {
        switch score {
        case 80...: return ColorSX.positive
        case 60..<80: return ColorSX.warning
        default: return ColorSX.accent
        }
    }
    
    var body: some View {
        ZStack {
            AnimatedBackgroundSX()
            ScrollView(showsIndicators: false){
                VStack(spacing: adaptyH(32)) {
                    Spacer()
                    badgeSection
                    scoreSection
                    summarySection
                    Spacer()
                    Group {
                        if !savedToStats {
                            Button { saveResult() } label: {
                                HStack {
                                    Image(systemName: "square.and.arrow.down")
                                    Text("Save Result")
                                }
                                .font(FontSX.label(17))
                                .foregroundStyle(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: adaptyH(54))
                                .background(GradientSX.gold)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            }
                        } else {
                            Label("Saved to Stats", systemImage: "checkmark.circle.fill")
                                .foregroundStyle(ColorSX.positive)
                                .font(FontSX.label(16))
                        }
                        Button {
                            dismiss()
                            dismiss()
                        } label: {
                            Text("Back to Tasks")
                                .font(FontSX.label(16))
                                .foregroundStyle(ColorSX.textSecondary)
                        }
                    }
                    .padding(.horizontal, adaptyW(32))
                    Spacer().frame(height: adaptyH(30))
                }
                .padding(.horizontal, adaptyW(24))
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.5).delay(0.2)) {
                badgeScale = 1.0
            }
        }
    }
    
    var badgeSection: some View {
        ZStack {
            Circle()
                .fill(gradeColor.opacity(0.15))
                .frame(width: adaptyW(140), height: adaptyH(140))
                .shadow(color: gradeColor.opacity(0.3), radius: 30)
            Circle()
                .strokeBorder(
                    AngularGradient(colors: [gradeColor, gradeColor.opacity(0.3), gradeColor], center: .center),
                    lineWidth: 2
                )
                .frame(width: adaptyW(140), height: adaptyH(140))
            Image(systemName: "trophy.fill")
                .font(.system(size: 56))
                .foregroundStyle(GradientSX.gold)
                .glowEffect(ColorSX.accentGold, radius: 16)
        }
        .scaleEffect(badgeScale)
    }
    
    var scoreSection: some View {
        VStack(spacing: 8) {
            Text(grade)
                .font(FontSX.display(32))
                .foregroundStyle(GradientSX.goldText)
            Text("\(score) / \(task.steps.count * 20) points")
                .font(FontSX.headline(18))
                .foregroundStyle(gradeColor)
        }
    }
    
    var summarySection: some View {
        GlowingCardSX(glowColor: gradeColor) {
            VStack(spacing: 14) {
                completionRow(label: "Task Completed", icon: "checkmark.circle.fill", color: ColorSX.positive)
                completionRow(label: "\(task.steps.count) Steps Finished", icon: "list.number", color: ColorSX.glowBlue)
                completionRow(label: "\(task.rewardPoints) Points Earned", icon: "star.fill", color: ColorSX.accentGold)
                completionRow(label: task.difficulty, icon: "flag.fill", color: gradeColor)
            }
        }
    }
    
    func completionRow(label: String, icon: String, color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(color)
            Text(label)
                .font(FontSX.body(15))
                .foregroundStyle(ColorSX.textPrimary)
            Spacer()
        }
    }
    
    func saveResult() {
        let completed = CompletedTaskSX(
            taskId: task.id,
            taskTitle: task.title,
            score: score,
            duration: task.durationMinutes,
            difficulty: task.difficulty
        )
        ctx.insert(completed)
        savedToStats = true
    }
}

#Preview {
    NavigationStack {
        TaskFinishViewSX(
            task: TrainingTaskModelSX(id: "t1", title: "Warm-Up", difficulty: "Beginner",
                                      durationMinutes: 15, category: "Conditioning",
                                      description: "Master warm-up.", steps: [], rewardPoints: 100),
            score: 100
        )
        .environment(MainViewModelSX())
    }
    .modelContainer(for: CompletedTaskSX.self, inMemory: true)
}
