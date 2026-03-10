import SwiftUI
import Observation

enum AppThemeSX: String, CaseIterable, Identifiable {
    case classic = "classic"
    case desert = "desertGold"
    case royal = "royalStable"
    case midnight = "midnightTrack"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .classic: return "Classic SX"
        case .desert: return "Desert Gold"
        case .royal: return "Royal Stable"
        case .midnight: return "Midnight Track"
        }
    }
}

@Observable
final class ThemeManagerSX {
    static let shared = ThemeManagerSX()
    
    var currentTheme: AppThemeSX = .classic {
        didSet {
            UserDefaults.standard.set(currentTheme.rawValue, forKey: "selectedThemeSX")
        }
    }
    
    private init() {
        if let saved = UserDefaults.standard.string(forKey: "selectedThemeSX"),
           let theme = AppThemeSX(rawValue: saved) {
            self.currentTheme = theme
        }
    }
}

enum ColorSX {
    static var background: Color {
        switch ThemeManagerSX.shared.currentTheme {
        case .classic: return Color(red: 0.04, green: 0.04, blue: 0.10)
        case .desert: return Color(red: 0.12, green: 0.08, blue: 0.04)
        case .royal: return Color(red: 0.08, green: 0.04, blue: 0.15)
        case .midnight: return Color(red: 0.02, green: 0.04, blue: 0.12)
        }
    }
    
    static var surface: Color {
        switch ThemeManagerSX.shared.currentTheme {
        case .classic: return Color(red: 0.08, green: 0.08, blue: 0.16)
        case .desert: return Color(red: 0.18, green: 0.12, blue: 0.08)
        case .royal: return Color(red: 0.12, green: 0.08, blue: 0.22)
        case .midnight: return Color(red: 0.05, green: 0.08, blue: 0.18)
        }
    }
    
    static var surfaceElevated: Color {
        switch ThemeManagerSX.shared.currentTheme {
        case .classic: return Color(red: 0.11, green: 0.11, blue: 0.22)
        case .desert: return Color(red: 0.22, green: 0.16, blue: 0.10)
        case .royal: return Color(red: 0.16, green: 0.11, blue: 0.28)
        case .midnight: return Color(red: 0.08, green: 0.11, blue: 0.25)
        }
    }
    
    static var accent: Color {
        switch ThemeManagerSX.shared.currentTheme {
        case .classic: return Color(red: 1.0, green: 0.78, blue: 0.20)
        case .desert: return desertGold
        case .royal: return royalStable
        case .midnight: return midnightTrack
        }
    }
    
    static let accentGold = Color(red: 1.0, green: 0.72, blue: 0.10)
    static let accentCream = Color(red: 1.0, green: 0.94, blue: 0.78)
    
    static var glowOrange: Color {
        switch ThemeManagerSX.shared.currentTheme {
        case .classic, .desert: return Color(red: 1.0, green: 0.55, blue: 0.10)
        case .royal: return Color(red: 0.85, green: 0.40, blue: 1.0)
        case .midnight: return Color(red: 0.40, green: 0.60, blue: 1.0)
        }
    }
    
    static let glowPurple = Color(red: 0.55, green: 0.30, blue: 1.0)
    static let glowBlue = Color(red: 0.20, green: 0.55, blue: 1.0)
    static let positive = Color(red: 0.25, green: 0.90, blue: 0.55)
    static let warning = Color(red: 1.0, green: 0.65, blue: 0.10)
    static let danger = Color(red: 1.0, green: 0.30, blue: 0.30)
    static let textPrimary = Color.white
    static let textSecondary = Color(white: 0.9)
    static let textMuted = Color(white: 0.6)
    static let separator = Color(white: 0.15)
    
    static let desertGold = Color(red: 0.95, green: 0.72, blue: 0.25)
    static let royalStable = Color(red: 0.65, green: 0.45, blue: 1.0)
    static let midnightTrack = Color(red: 0.35, green: 0.65, blue: 1.0)
}

enum GradientSX {
    static var background: LinearGradient {
        switch ThemeManagerSX.shared.currentTheme {
        case .classic:
            return LinearGradient(
                colors: [Color(red: 0.04, green: 0.04, blue: 0.12), Color(red: 0.07, green: 0.04, blue: 0.18)],
                startPoint: .top, endPoint: .bottom
            )
        case .desert:
            return desertTheme
        case .royal:
            return royalTheme
        case .midnight:
            return midnightTheme
        }
    }
    
    static var gold: LinearGradient {
        switch ThemeManagerSX.shared.currentTheme {
        case .classic, .desert:
            return LinearGradient(
                colors: [Color(red: 1.0, green: 0.85, blue: 0.30), Color(red: 0.85, green: 0.55, blue: 0.05)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        case .royal:
            return LinearGradient(
                colors: [Color(red: 0.9, green: 0.7, blue: 1.0), Color(red: 0.6, green: 0.3, blue: 0.9)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        case .midnight:
            return LinearGradient(
                colors: [Color(red: 0.7, green: 0.9, blue: 1.0), Color(red: 0.3, green: 0.6, blue: 0.9)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        }
    }
    
    static var goldText: LinearGradient {
        switch ThemeManagerSX.shared.currentTheme {
        case .classic, .desert:
            return LinearGradient(
                colors: [Color(red: 1.0, green: 0.92, blue: 0.50), Color(red: 1.0, green: 0.72, blue: 0.10)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        case .royal:
            return LinearGradient(
                colors: [Color(red: 0.95, green: 0.85, blue: 1.0), Color(red: 0.75, green: 0.55, blue: 1.0)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        case .midnight:
            return LinearGradient(
                colors: [Color(red: 0.85, green: 0.95, blue: 1.0), Color(red: 0.55, green: 0.85, blue: 1.0)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        }
    }
    
    static var card: LinearGradient {
        LinearGradient(
            colors: [ColorSX.surfaceElevated, ColorSX.surface],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
    }
    
    static var accent: LinearGradient {
        LinearGradient(
            colors: [ColorSX.accent, ColorSX.glowOrange],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
    }
    
    static let desertTheme = LinearGradient(
        colors: [Color(red: 0.20, green: 0.14, blue: 0.05), Color(red: 0.10, green: 0.08, blue: 0.02)],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    static let royalTheme = LinearGradient(
        colors: [Color(red: 0.18, green: 0.08, blue: 0.35), Color(red: 0.10, green: 0.04, blue: 0.20)],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    static let midnightTheme = LinearGradient(
        colors: [Color(red: 0.04, green: 0.10, blue: 0.25), Color(red: 0.02, green: 0.05, blue: 0.15)],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
}

enum FontSX {
    static func display(_ size: CGFloat) -> Font { .system(size: size, weight: .black, design: .rounded) }
    static func headline(_ size: CGFloat) -> Font { .system(size: size, weight: .bold, design: .rounded) }
    static func body(_ size: CGFloat) -> Font { .system(size: size, weight: .regular, design: .rounded) }
    static func caption(_ size: CGFloat) -> Font { .system(size: size, weight: .medium, design: .rounded) }
    static func label(_ size: CGFloat) -> Font { .system(size: size, weight: .semibold, design: .rounded) }
}

struct GlowModifier: ViewModifier {
    let color: Color
    let radius: CGFloat
    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(0.6), radius: radius / 2)
            .shadow(color: color.opacity(0.3), radius: radius)
    }
}

extension View {
    func glowEffect(_ color: Color, radius: CGFloat = 12) -> some View {
        modifier(GlowModifier(color: color, radius: radius))
    }
}

struct AnimatedBackgroundSX: View {
    var body: some View {
        ZStack {
            GradientSX.background.ignoresSafeArea()
            Canvas { ctx, size in
                let c1 = Path(ellipseIn: CGRect(x: -60, y: -60, width: 340, height: 340))
                ctx.fill(c1, with: .color(ColorSX.accent.opacity(0.08)))
                let c2 = Path(ellipseIn: CGRect(x: size.width - 200, y: size.height - 250, width: 320, height: 320))
                ctx.fill(c2, with: .color(ColorSX.glowOrange.opacity(0.06)))
            }
            HorseOutlineSX()
                .fill(ColorSX.accent.opacity(0.04))
                .frame(width: adaptyW(320), height: adaptyH(320))
                .offset(x: adaptyW(60), y: adaptyH(-40))
        }
    }
}

struct HorseOutlineSX: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        p.move(to: CGPoint(x: w * 0.35, y: h * 0.85))
        p.addLine(to: CGPoint(x: w * 0.35, y: h * 0.60))
        p.addCurve(to: CGPoint(x: w * 0.20, y: h * 0.30),
                   control1: CGPoint(x: w * 0.32, y: h * 0.50),
                   control2: CGPoint(x: w * 0.22, y: h * 0.42))
        p.addCurve(to: CGPoint(x: w * 0.38, y: h * 0.15),
                   control1: CGPoint(x: w * 0.18, y: h * 0.18),
                   control2: CGPoint(x: w * 0.28, y: h * 0.12))
        p.addCurve(to: CGPoint(x: w * 0.55, y: h * 0.20),
                   control1: CGPoint(x: w * 0.48, y: h * 0.17),
                   control2: CGPoint(x: w * 0.52, y: h * 0.18))
        p.addCurve(to: CGPoint(x: w * 0.75, y: h * 0.40),
                   control1: CGPoint(x: w * 0.65, y: h * 0.22),
                   control2: CGPoint(x: w * 0.74, y: h * 0.32))
        p.addLine(to: CGPoint(x: w * 0.80, y: h * 0.60))
        p.addLine(to: CGPoint(x: w * 0.80, y: h * 0.85))
        p.addLine(to: CGPoint(x: w * 0.65, y: h * 0.85))
        p.addLine(to: CGPoint(x: w * 0.65, y: h * 0.60))
        p.addLine(to: CGPoint(x: w * 0.50, y: h * 0.60))
        p.addLine(to: CGPoint(x: w * 0.50, y: h * 0.85))
        p.closeSubpath()
        return p
    }
}

