import SwiftUI
import StoreKit

struct GlowingCardSX<Content: View>: View {
    let content: Content
    var glowColor: Color = ColorSX.accent
    var glowRadius: CGFloat = 12
    var padding: CGFloat = 18
    
    init(glowColor: Color = ColorSX.accent, glowRadius: CGFloat = 12, padding: CGFloat = 18, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.glowColor = glowColor
        self.glowRadius = glowRadius
        self.padding = padding
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(GradientSX.card)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .strokeBorder(glowColor.opacity(0.3), lineWidth: 1)
                    )
            )
            .shadow(color: glowColor.opacity(0.18), radius: glowRadius, x: 0, y: 4)
    }
}

struct HorseStatBarSX: View {
    let label: String
    let value: Int
    let max: Int
    var color: Color = ColorSX.accent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(label)
                    .font(FontSX.caption(12))
                    .foregroundStyle(ColorSX.textSecondary)
                Spacer()
                Text("\(value)")
                    .font(FontSX.label(12))
                    .foregroundStyle(color)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color.opacity(0.15))
                        .frame(height: 6)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(LinearGradient(colors: [color, color.opacity(0.7)], startPoint: .leading, endPoint: .trailing))
                        .frame(width: geo.size.width * CGFloat(value) / CGFloat(max), height: 6)
                        .shadow(color: color.opacity(0.5), radius: 4)
                }
            }
            .frame(height: 6)
        }
    }
}

struct TrainingProgressViewSX: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalSteps, id: \.self) { index in
                if index < currentStep {
                    Circle()
                        .fill(GradientSX.gold)
                        .frame(width: 10, height: 10)
                        .shadow(color: ColorSX.accent.opacity(0.6), radius: 4)
                } else if index == currentStep {
                    Circle()
                        .strokeBorder(ColorSX.accent, lineWidth: 2)
                        .frame(width: 10, height: 10)
                        .scaleEffect(1.2)
                } else {
                    Circle()
                        .fill(ColorSX.separator)
                        .frame(width: 10, height: 10)
                }
                if index < totalSteps - 1 {
                    Rectangle()
                        .fill(index < currentStep ? ColorSX.accent.opacity(0.5) : ColorSX.separator)
                        .frame(maxWidth: .infinity)
                        .frame(height: 2)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct PremiumBadgeSX: View {
    var body: some View {
        HStack{
            Image(systemName: "star.fill")
                .font(.system(size: 9))
                .foregroundStyle(GradientSX.gold)
            Text("PRO")
                .font(.system(size: 10, weight: .black, design: .rounded))
                .foregroundStyle(GradientSX.gold)
                .lineLimit(1)
                .fixedSize()
        }
        .minimumScaleFactor(0.8)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            ColorSX.accentGold.opacity(0.2)
                .overlay(
                    Capsule()
                    .strokeBorder(ColorSX.accentGold.opacity(0.5), lineWidth: 1)
                )
        )
        .clipShape(.capsule)
    }
}

struct BlurLockedCardSX: View {
    @Environment(IAPManagerVE.self) private var iap
    let title: String
    let subtitle: String
    let productId: String
    var onUnlock: () -> Void
    
    var body: some View {
        let product = iap.products.first { $0.productIdentifier == productId }
        
        ZStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(FontSX.headline(16))
                    .foregroundStyle(ColorSX.textPrimary)
                Text(subtitle)
                    .font(FontSX.body(13))
                    .foregroundStyle(ColorSX.textSecondary)
                    .lineLimit(2)
            }
            .padding(18)
            .blur(radius: 7)
            
            VStack(spacing: 12) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(GradientSX.gold)
                    .glowEffect(ColorSX.accentGold, radius: 12)
                PremiumBadgeSX()
                Button(action: onUnlock) {
                    Text("Unlock – \(product?.localizedPriceVE ?? "$1.99")")
                        .font(FontSX.label(14))
                        .foregroundStyle(.black)
                        .padding(.horizontal, adaptyW(20))
                        .padding(.vertical, 10)
                        .background(GradientSX.gold)
                        .clipShape(Capsule())
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(GradientSX.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .strokeBorder(ColorSX.accentGold.opacity(0.35), lineWidth: 1)
                )
        )
    }
}

struct DifficultyBadgeSX: View {
    let difficulty: String
    var body: some View {
        Text(difficulty)
            .font(FontSX.caption(11))
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(badgeColor.opacity(0.2))
            .foregroundStyle(badgeColor)
            .clipShape(Capsule())
    }
    var badgeColor: Color {
        switch difficulty {
        case "Beginner": return ColorSX.positive
        case "Intermediate": return ColorSX.warning
        default: return ColorSX.danger
        }
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
