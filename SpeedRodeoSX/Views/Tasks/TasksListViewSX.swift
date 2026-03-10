import SwiftUI

struct TasksListViewSX: View {
    @Environment(MainViewModelSX.self) private var viewModel
    @State private var selectedTask: TrainingTaskModelSX? = nil
    @State private var selectedDifficulty: String = "All"

    var difficulties: [String] { ["All", "Beginner", "Intermediate", "Advanced"] }

    var filtered: [TrainingTaskModelSX] {
        if selectedDifficulty == "All" { return viewModel.trainingTasks }
        return viewModel.trainingTasks.filter { $0.difficulty == selectedDifficulty }
    }

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            AnimatedBackgroundSX()
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
                    Section {
                        LazyVStack(spacing: 14) {
                            ForEach(filtered) { task in
                                Button { selectedTask = task } label: {
                                    TaskRowCardSX(task: task)
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
                            HStack(spacing: 12) {
                                Button { dismiss() } label: {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundStyle(ColorSX.textPrimary)
                                        .frame(width: 38, height: 38)
                                        .background(Circle().fill(ColorSX.surfaceElevated))
                                }
                                
                                Text("Training Tasks")
                                    .font(FontSX.display(26))
                                    .foregroundStyle(GradientSX.goldText)
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(difficulties, id: \.self) { diff in
                                        Button {
                                            withAnimation(.spring(response: 0.3)) {
                                                selectedDifficulty = diff
                                            }
                                        } label: {
                                            Text(diff)
                                                .font(FontSX.label(13))
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 8)
                                                .background(Capsule().fill(selectedDifficulty == diff ? ColorSX.accent : ColorSX.surface))
                                                .foregroundStyle(selectedDifficulty == diff ? .black : ColorSX.textSecondary)
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
        .navigationDestination(item: $selectedTask) { task in
            TaskDetailsViewSX(task: task).environment(viewModel)
        }
    }
}

struct TaskRowCardSX: View {
    let task: TrainingTaskModelSX

    var body: some View {
        GlowingCardSX(glowColor: difficultyColor, padding: 16) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(difficultyColor.opacity(0.15))
                        .frame(width: adaptyW(50), height: adaptyH(50))
                    Image(systemName: categoryIcon)
                        .font(.system(size: 22))
                        .foregroundStyle(difficultyColor)
                }
                VStack(alignment: .leading, spacing: 6) {
                    Text(task.title)
                        .font(FontSX.headline(15))
                        .foregroundStyle(ColorSX.textPrimary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    HStack(spacing: 8) {
                        DifficultyBadgeSX(difficulty: task.difficulty)
                        Image(systemName: "clock")
                            .font(.system(size: 11))
                            .foregroundStyle(ColorSX.textMuted)
                        Text("\(task.durationMinutes) min")
                            .font(FontSX.caption(12))
                            .foregroundStyle(ColorSX.textMuted)
                        Image(systemName: "star.fill")
                            .font(.system(size: 11))
                            .foregroundStyle(ColorSX.accentGold)
                        Text("\(task.rewardPoints) pts")
                            .font(FontSX.caption(12))
                            .foregroundStyle(ColorSX.textMuted)
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(ColorSX.textMuted)
                    .font(.system(size: 13))
            }
        }
    }

    var difficultyColor: Color {
        switch task.difficulty {
        case "Beginner": return ColorSX.positive
        case "Intermediate": return ColorSX.warning
        default: return ColorSX.danger
        }
    }

    var categoryIcon: String {
        switch task.category {
        case "Conditioning": return "figure.run"
        case "Stable Management": return "house.fill"
        case "Equipment": return "wrench.fill"
        case "Rider Skills": return "figure.equestrian.sports"
        case "Race Strategy": return "flag.checkered"
        case "Recovery": return "heart.fill"
        case "Nutrition": return "leaf.fill"
        case "Psychology": return "brain.head.profile"
        case "Veterinary": return "cross.fill"
        default: return "dumbbell.fill"
        }
    }
}

#Preview {
    TasksListViewSX().environment(MainViewModelSX())
}
