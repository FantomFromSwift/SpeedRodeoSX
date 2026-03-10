import SwiftUI

struct SplashViewSX: View {
    @State private var glowOpacity: Double = 0.0
    @State private var glowRadius: Double = 10
    @State private var horseScale: Double = 0.7
    @State private var ringRotation: Double = 0
    @State private var titleOpacity: Double = 0.0
    @State private var dotPhase: Int = 0

    let onFinish: () -> Void

    var body: some View {
        ZStack {
            GradientSX.background.ignoresSafeArea()

            Circle()
                .fill(ColorSX.accentGold.opacity(0.07))
                .frame(width: adaptyW(380), height: adaptyH(380))
                .blur(radius: 60)
                .rotationEffect(.degrees(ringRotation))

            Circle()
                .fill(ColorSX.glowPurple.opacity(0.06))
                .frame(width: adaptyW(280), height: adaptyH(280))
                .blur(radius: 40)
                .offset(x: 80, y: -60)

            Circle()
                .strokeBorder(
                    AngularGradient(
                        colors: [ColorSX.accent, ColorSX.accent.opacity(0.1), ColorSX.accent],
                        center: .center
                    ),
                    lineWidth: 1.5
                )
                .frame(width: adaptyW(240), height: adaptyH(240))
                .rotationEffect(.degrees(ringRotation))
                .opacity(glowOpacity)

            HorseOutlineSX()
                .fill(
                    LinearGradient(
                        colors: [ColorSX.accent, ColorSX.accentGold],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: adaptyW(160), height: adaptyH(160))
                .scaleEffect(horseScale)
                .shadow(color: ColorSX.accent.opacity(0.6), radius: 20)
                .shadow(color: ColorSX.accentGold.opacity(0.3), radius: 40)
                .opacity(glowOpacity)

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 6) {
                    Text("SPEED RODEO")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundStyle(GradientSX.goldText)
                        .tracking(4)
                    Text("SX")
                        .font(.system(size: 48, weight: .black, design: .rounded))
                        .foregroundStyle(GradientSX.goldText)
                        .tracking(8)
                        .glowEffect(ColorSX.accentGold, radius: 14)
                }
                .opacity(titleOpacity)

                Spacer().frame(height: adaptyH(60))

                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { i in
                        Circle()
                            .fill(i == dotPhase % 3 ? ColorSX.accent : ColorSX.separator)
                            .frame(width: 8, height: 8)
                            .scaleEffect(i == dotPhase % 3 ? 1.3 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: dotPhase)
                    }
                }
                .opacity(glowOpacity)

                Spacer().frame(height: adaptyH(60))
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                glowOpacity = 1.0
                horseScale = 1.0
            }
            withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                ringRotation = 360
            }
            withAnimation(.easeInOut(duration: 0.5).delay(0.4)) {
                titleOpacity = 1.0
            }
            Timer.scheduledTimer(withTimeInterval: 0.35, repeats: true) { t in
                dotPhase += 1
                if dotPhase > 100 { t.invalidate() }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8, execute: onFinish)
        }
    }
}

#Preview {
    SplashViewSX {}
}
