import SwiftUI
import SwiftData

struct ArticlesViewSX: View {
    @Environment(MainViewModelSX.self) private var viewModel
    @Query private var favorites: [FavoriteItemSX]
    @State private var selectedArticle: ArticleModelSX? = nil
    @State private var selectedCategory: String = "All"

    var categories: [String] {
        var cats = ["All"]
        let unique = Set(viewModel.articles.map(\.category))
        cats.append(contentsOf: unique.sorted())
        return cats
    }

    var filtered: [ArticleModelSX] {
        if selectedCategory == "All" { return viewModel.articles }
        return viewModel.articles.filter { $0.category == selectedCategory }
    }

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            AnimatedBackgroundSX()
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
                    Section {
                        LazyVStack(spacing: 14) {
                            ForEach(filtered) { article in
                                Button {
                                    selectedArticle = article
                                } label: {
                                    ArticleRowCardSX(article: article, isFav: favorites.contains { $0.itemId == article.id })
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
                                
                                Text("Articles")
                                    .font(FontSX.display(28))
                                    .foregroundStyle(GradientSX.goldText)
                                Spacer()
                                Text("\(filtered.count) articles")
                                    .font(FontSX.caption(13))
                                    .foregroundStyle(ColorSX.textMuted)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(categories, id: \.self) { cat in
                                        Button {
                                            withAnimation(.spring(response: 0.3)) {
                                                selectedCategory = cat
                                            }
                                        } label: {
                                            Text(cat)
                                                .font(FontSX.label(13))
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 8)
                                                .background(
                                                    Capsule()
                                                        .fill(selectedCategory == cat ? ColorSX.accent : ColorSX.surface)
                                                )
                                                .foregroundStyle(selectedCategory == cat ? .black : ColorSX.textSecondary)
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
        .navigationDestination(item: $selectedArticle) { article in
            ArticleDetailViewSX(article: article)
        }
    }
}

struct ArticleRowCardSX: View {
    let article: ArticleModelSX
    let isFav: Bool

    var body: some View {
        GlowingCardSX(glowColor: ColorSX.glowBlue, padding: 16) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(ColorSX.glowBlue.opacity(0.15))
                        .frame(width: adaptyW(50), height: adaptyH(50))
                    Image(systemName: categoryIcon(article.category))
                        .font(.system(size: 20))
                        .foregroundStyle(ColorSX.glowBlue)
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text(article.title)
                        .font(FontSX.headline(15))
                        .foregroundStyle(ColorSX.textPrimary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    HStack(spacing: 8) {
                        Text(article.category)
                            .font(FontSX.caption(11))
                            .foregroundStyle(ColorSX.glowBlue)
                        Text("•")
                            .foregroundStyle(ColorSX.textMuted)
                        Text("\(article.readingMinutes) min read")
                            .font(FontSX.caption(11))
                            .foregroundStyle(ColorSX.textMuted)
                    }
                }
                Spacer()
                if isFav {
                    Image(systemName: "heart.fill")
                        .foregroundStyle(ColorSX.danger)
                        .font(.system(size: 14))
                }
            }
        }
    }

    func categoryIcon(_ cat: String) -> String {
        switch cat {
        case "Horse Breeds": return "hare.fill"
        case "Jockey Training": return "figure.equestrian.sports"
        case "Race Science": return "speedometer"
        case "Nutrition": return "leaf.fill"
        case "Training Methods": return "dumbbell.fill"
        case "Stable Care": return "house.fill"
        case "Performance Science": return "waveform.path.ecg"
        case "Race Strategy": return "flag.checkered"
        default: return "newspaper.fill"
        }
    }
}

#Preview {
    ArticlesViewSX().environment(MainViewModelSX())
}
