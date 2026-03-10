import SwiftUI
import SwiftData

struct ArticleDetailViewSX: View {
    let article: ArticleModelSX
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var ctx
    @Query private var favorites: [FavoriteItemSX]
    @State private var scrollProgress: Double = 0
    @State private var isBookmarked: Bool = false

    var isFavorited: Bool { favorites.contains { $0.itemId == article.id } }

    var body: some View {
        ZStack {
            AnimatedBackgroundSX()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    articleHero
                    articleContent
                    Spacer().frame(height: adaptyH(100))
                }
            }
            .coordinateSpace(name: "SCROLL")
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarHidden(true)
        .safeAreaInset(edge: .top) { topBar }
    }

    var topBar: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(ColorSX.textPrimary)
                    .frame(width: adaptyW(38), height: adaptyH(38))
                    .background(Circle().fill(.ultraThinMaterial))
            }
            Spacer()
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2).fill(ColorSX.separator).frame(height: 4)
                    RoundedRectangle(cornerRadius: 2).fill(ColorSX.accent)
                        .frame(width: max(0, geo.size.width * scrollProgress), height: 4)
                }
            }
            .frame(maxWidth: 120, maxHeight: 4)
            Spacer()
            Button { toggleFavorite() } label: {
                Image(systemName: isFavorited ? "heart.fill" : "heart")
                    .font(.system(size: 18))
                    .foregroundStyle(isFavorited ? ColorSX.danger : ColorSX.textPrimary)
                    .frame(width: adaptyW(38), height: adaptyH(38))
                    .background(Circle().fill(.ultraThinMaterial))
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 8)
        .background(.ultraThinMaterial)
    }

    var articleHero: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [heroColor(for: article.category), heroColor(for: article.category).opacity(0.3)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .frame(height: adaptyH(220))
            HorseOutlineSX()
                .fill(Color.white.opacity(0.04))
                .frame(width: adaptyW(200), height: adaptyH(200))
                .offset(x: adaptyW(160), y: adaptyH(-10))
            VStack(alignment: .leading, spacing: 6) {
                Text(article.category)
                    .font(FontSX.caption(12))
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .background(Capsule().fill(.white.opacity(0.15)))
                Text(article.title)
                    .font(FontSX.display(22))
                    .foregroundStyle(.white)
                    .lineLimit(3)
                Text("\(article.readingMinutes) min read")
                    .font(FontSX.caption(12))
                    .foregroundStyle(.white.opacity(0.7))
            }
            .padding(adaptyW(20))
        }
    }

    var articleContent: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "quote.opening")
                        .font(.title3)
                        .foregroundStyle(ColorSX.accent)
                    Text("Introduction")
                        .font(FontSX.label(13))
                        .foregroundStyle(ColorSX.accent)
                        .textCase(.uppercase)
                }
                
                Text(article.summary)
                    .font(FontSX.headline(17))
                    .foregroundStyle(ColorSX.textPrimary)
                    .lineSpacing(4)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(ColorSX.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(ColorSX.accent.opacity(0.2), lineWidth: 1)
                    )
            )
            .padding(.top, 24)

            let paragraphs = article.body.components(separatedBy: "\n\n")
            ForEach(paragraphs.indices, id: \.self) { index in
                let text = paragraphs[index].trimmingCharacters(in: .whitespacesAndNewlines)
                if !text.isEmpty {
                    ArticleBlockSX(text: text, index: index)
                }
            }
        }
        .padding(.horizontal, 20)
    }
    func heroColor(for category: String) -> Color {
        switch category {
        case "Horse Breeds": return ColorSX.accentGold
        case "Jockey Training": return ColorSX.glowOrange
        case "Race Science": return ColorSX.glowBlue
        case "Nutrition": return ColorSX.positive
        case "Training Methods": return ColorSX.glowPurple
        default: return ColorSX.accent
        }
    }

    func toggleFavorite() {
        if let existing = favorites.first(where: { $0.itemId == article.id }) {
            ctx.delete(existing)
        } else {
            ctx.insert(FavoriteItemSX(itemId: article.id, itemType: "article", title: article.title, subtitle: article.category))
        }
    }
}


struct ArticleBlockSX: View {
    let text: String
    let index: Int
    
    var isHeader: Bool {
        text.count < 50 && (text.hasSuffix(":") || text.allSatisfy { $0.isUppercase || $0.isWhitespace || $0.isPunctuation })
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            if isHeader {
                Text(text)
                    .font(FontSX.display(20))
                    .foregroundStyle(GradientSX.goldText)
                    .padding(.top, 8)
            } else {
                HStack(alignment: .top, spacing: 14) {
                    
                    Text("\(index + 1)")
                        .font(FontSX.caption(10))
                        .foregroundStyle(ColorSX.textMuted)
                        .frame(width: 20, height: 20)
                        .background(Circle().stroke(ColorSX.separator, lineWidth: 1))
                        .padding(.top, 4)
                    
                    Text(text)
                        .font(FontSX.body(16))
                        .foregroundStyle(ColorSX.textSecondary)
                        .lineSpacing(6)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(ColorSX.surface.opacity(0.5))
                        .shadow(color: Color.black.opacity(0.1), radius: 10, y: 5)
                )
            }
        }
    }
}


#Preview {
    NavigationStack {
        ArticleDetailViewSX(article: ArticleModelSX(
            id: "preview", title: "The Thoroughbred: Born to Run",
            category: "Horse Breeds", summary: "A deep dive into the genetic and physical traits.",
            body: "This is the full article body text...", readingMinutes: 8, imageName: "thoroughbred_gallop"
        ))
    }
    .modelContainer(for: FavoriteItemSX.self, inMemory: true)
}
