import SwiftUI
import SwiftData

struct SearchViewSX: View {
    @Environment(MainViewModelSX.self) private var viewModel
    @State private var selectedArticle: ArticleModelSX? = nil
    @State private var selectedTask: TrainingTaskModelSX? = nil
    @State private var selectedHorse: HorseBreedModelSX? = nil
    @FocusState private var searchFocused: Bool

    var results: SearchResultsSX { viewModel.searchResults() }

    var body: some View {
        NavigationStack {
            ZStack {
                AnimatedBackgroundSX()
                VStack(spacing: 0) {
                    searchHeader
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: adaptyH(20)) {
                            if !results.articles.isEmpty {
                                searchSection(title: "Articles", icon: "newspaper.fill", color: ColorSX.glowBlue) {
                                    ForEach(results.articles.prefix(5)) { article in
                                        Button { selectedArticle = article } label: {
                                            searchRow(title: article.title, subtitle: article.category, icon: "newspaper.fill", color: ColorSX.glowBlue)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                            if !results.tasks.isEmpty {
                                searchSection(title: "Training Tasks", icon: "figure.equestrian.sports", color: ColorSX.glowOrange) {
                                    ForEach(results.tasks.prefix(5)) { task in
                                        Button { selectedTask = task } label: {
                                            searchRow(title: task.title, subtitle: task.difficulty, icon: "figure.equestrian.sports", color: ColorSX.glowOrange)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                            if !results.horses.isEmpty {
                                searchSection(title: "Horse Breeds", icon: "hare.fill", color: ColorSX.accentGold) {
                                    ForEach(results.horses.prefix(5)) { horse in
                                        Button { selectedHorse = horse } label: {
                                            searchRow(title: horse.name, subtitle: horse.origin, icon: "hare.fill", color: ColorSX.accentGold)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                            if results.articles.isEmpty && results.tasks.isEmpty && results.horses.isEmpty {
                                emptyState
                            }
                            Spacer().frame(height: adaptyH(100))
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                    }
                }
            }
            .navigationDestination(item: $selectedArticle) { ArticleDetailViewSX(article: $0) }
            .navigationDestination(item: $selectedTask) { TaskDetailsViewSX(task: $0).environment(viewModel) }
            .navigationDestination(item: $selectedHorse) { HorseDetailViewSX(horse: $0) }
        }
    }

    var searchHeader: some View {
        VStack(spacing: 12) {
            Text("Search")
                .font(FontSX.display(28))
                .foregroundStyle(GradientSX.goldText)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.top, 14)
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(ColorSX.textMuted)
                TextField("Search articles, tasks, horses...", text: Bindable(viewModel).searchQuery)
                    .font(FontSX.body(16))
                    .foregroundStyle(ColorSX.textPrimary)
                    .focused($searchFocused)
                if !viewModel.searchQuery.isEmpty {
                    Button { viewModel.searchQuery = "" } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(ColorSX.textMuted)
                    }
                }
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(ColorSX.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(searchFocused ? ColorSX.accent.opacity(0.5) : ColorSX.separator, lineWidth: 1)
                    )
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
        }
        .background(.ultraThinMaterial)
    }

    func searchSection<Content: View>(title: String, icon: String, color: Color, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: icon).foregroundStyle(color).font(.system(size: 13))
                Text(title).font(FontSX.label(14)).foregroundStyle(ColorSX.textPrimary)
            }
            content()
        }
    }

    func searchRow(title: String, subtitle: String, icon: String, color: Color) -> some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10).fill(color.opacity(0.18)).frame(width: adaptyW(40), height: adaptyH(40))
                Image(systemName: icon).font(.system(size: 16)).foregroundStyle(color)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(title).font(FontSX.label(14)).foregroundStyle(ColorSX.textPrimary).lineLimit(1)
                Text(subtitle).font(FontSX.caption(12)).foregroundStyle(ColorSX.textMuted)
            }
            Spacer()
            Image(systemName: "chevron.right").font(.system(size: 12)).foregroundStyle(ColorSX.textMuted)
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 12).fill(ColorSX.surface))
    }

    var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 44))
                .foregroundStyle(ColorSX.textMuted)
            Text("No results found")
                .font(FontSX.headline(18))
                .foregroundStyle(ColorSX.textSecondary)
            Text("Try a different search term or browse the Journal.")
                .font(FontSX.body(14))
                .foregroundStyle(ColorSX.textMuted)
                .multilineTextAlignment(.center)
        }
        .padding(adaptyW(40))
    }
}

#Preview {
    SearchViewSX().environment(MainViewModelSX())
}
