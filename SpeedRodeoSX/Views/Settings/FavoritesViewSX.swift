import SwiftUI
import SwiftData

struct FavoritesViewSX: View {
    @Environment(MainViewModelSX.self) private var viewModel
    @Environment(\.modelContext) private var ctx
    @Query(sort: \FavoriteItemSX.savedAt, order: .reverse) private var favorites: [FavoriteItemSX]
    @Query private var completedTasks: [CompletedTaskSX]
    @State private var selectedArticle: ArticleModelSX? = nil
    @State private var selectedHorse: HorseBreedModelSX? = nil

    var savedArticles: [FavoriteItemSX] { favorites.filter { $0.itemType == "article" } }
    var savedHorses: [FavoriteItemSX] { favorites.filter { $0.itemType == "horse" } }

    var body: some View {
        NavigationStack {
            ZStack {
                AnimatedBackgroundSX()
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: adaptyH(22)) {
                        statsRow
                        if !savedArticles.isEmpty { articleSection }
                        if !savedHorses.isEmpty { horseSection }
                        if !completedTasks.isEmpty { completedSection }
                        if favorites.isEmpty && completedTasks.isEmpty { emptyState }
                        Spacer().frame(height: adaptyH(100))
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
            }
            .safeAreaInset(edge: .top) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Favorites")
                            .font(FontSX.display(30))
                            .foregroundStyle(GradientSX.goldText)
                    }
                    Spacer()
                    Image(systemName: "heart.fill")
                        .font(.system(size: 26))
                        .foregroundStyle(GradientSX.gold)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(.ultraThinMaterial)
            }
            .navigationDestination(item: $selectedArticle) { ArticleDetailViewSX(article: $0) }
            .navigationDestination(item: $selectedHorse) { HorseDetailViewSX(horse: $0) }
        }
    }

    var statsRow: some View {
        HStack(spacing: 12) {
            statTile(value: "\(savedArticles.count)", label: "Saved Articles", icon: "newspaper.fill", color: ColorSX.glowBlue)
            statTile(value: "\(completedTasks.count)", label: "Tasks Done", icon: "checkmark.circle.fill", color: ColorSX.positive)
            let avg = completedTasks.isEmpty ? 0 : completedTasks.map(\.score).reduce(0, +) / completedTasks.count
            statTile(value: "\(avg)%", label: "Avg Score", icon: "star.fill", color: ColorSX.accentGold)
        }
    }

    func statTile(value: String, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon).font(.system(size: 18)).foregroundStyle(color)
            Text(value).font(FontSX.display(22)).foregroundStyle(color)
            Text(label).font(FontSX.caption(10)).foregroundStyle(ColorSX.textMuted).multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(GradientSX.card)
                .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(color.opacity(0.25), lineWidth: 1))
        )
    }

    var articleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Saved Articles").font(FontSX.label(14)).foregroundStyle(ColorSX.textMuted)
            ForEach(savedArticles) { fav in
                HStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10).fill(ColorSX.glowBlue.opacity(0.18)).frame(width: adaptyW(40), height: adaptyH(40))
                        Image(systemName: "newspaper.fill").font(.system(size: 16)).foregroundStyle(ColorSX.glowBlue)
                    }
                    VStack(alignment: .leading, spacing: 3) {
                        Text(fav.title).font(FontSX.label(14)).foregroundStyle(ColorSX.textPrimary).lineLimit(2)
                        Text(fav.subtitle).font(FontSX.caption(12)).foregroundStyle(ColorSX.textMuted)
                    }
                    Spacer()
                    Button { ctx.delete(fav) } label: {
                        Image(systemName: "heart.fill").foregroundStyle(ColorSX.danger)
                    }
                }
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 12).fill(ColorSX.surface))
                .onTapGesture {
                    if let article = viewModel.articles.first(where: { $0.id == fav.itemId }) {
                        selectedArticle = article
                    }
                }
            }
        }
    }

    var horseSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Saved Breeds").font(FontSX.label(14)).foregroundStyle(ColorSX.textMuted)
            ForEach(savedHorses) { fav in
                HStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10).fill(ColorSX.accentGold.opacity(0.18)).frame(width: adaptyW(40), height: adaptyH(40))
                        HorseOutlineSX().fill(GradientSX.gold).frame(width: adaptyW(24), height: adaptyH(24))
                    }
                    VStack(alignment: .leading, spacing: 3) {
                        Text(fav.title).font(FontSX.label(14)).foregroundStyle(ColorSX.textPrimary)
                        Text(fav.subtitle).font(FontSX.caption(12)).foregroundStyle(ColorSX.textMuted)
                    }
                    Spacer()
                    Button { ctx.delete(fav) } label: {
                        Image(systemName: "heart.fill").foregroundStyle(ColorSX.danger)
                    }
                }
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 12).fill(ColorSX.surface))
            }
        }
    }

    var completedSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Completed Tasks").font(FontSX.label(14)).foregroundStyle(ColorSX.textMuted)
            ForEach(completedTasks.prefix(5)) { task in
                HStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10).fill(ColorSX.positive.opacity(0.18)).frame(width: adaptyW(40), height: adaptyH(40))
                        Image(systemName: "checkmark.circle.fill").font(.system(size: 18)).foregroundStyle(ColorSX.positive)
                    }
                    VStack(alignment: .leading, spacing: 3) {
                        Text(task.taskTitle).font(FontSX.label(14)).foregroundStyle(ColorSX.textPrimary)
                        Text("\(task.score) pts • \(task.difficulty)").font(FontSX.caption(12)).foregroundStyle(ColorSX.textMuted)
                    }
                    Spacer()
                    Text("\(task.score)%").font(FontSX.label(13)).foregroundStyle(ColorSX.positive)
                }
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 12).fill(ColorSX.surface))
            }
        }
    }

    var emptyState: some View {
        VStack(spacing: adaptyH(20)) {
            Image(systemName: "heart")
                .font(.system(size: 52))
                .foregroundStyle(ColorSX.textMuted)
            Text("Nothing saved yet")
                .font(FontSX.headline(20))
                .foregroundStyle(ColorSX.textSecondary)
            Text("Bookmark articles and complete tasks to build your collection here.")
                .font(FontSX.body(14))
                .foregroundStyle(ColorSX.textMuted)
                .multilineTextAlignment(.center)
        }
        .padding(adaptyW(40))
    }
}

#Preview {
    FavoritesViewSX()
        .environment(MainViewModelSX())
        .modelContainer(for: [FavoriteItemSX.self, CompletedTaskSX.self], inMemory: true)
}
