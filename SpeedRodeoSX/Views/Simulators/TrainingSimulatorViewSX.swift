import SwiftUI
import SwiftData

struct TrainingSimulatorViewSX: View {
    @Environment(MainViewModelSX.self) private var viewModel
    @Environment(\.modelContext) private var ctx

    let horses = ["Thoroughbred", "Arabian", "Quarter Horse", "Standardbred", "Akhal-Teke"]
    let tracks = ["Turf", "Dirt", "Synthetic", "Sand"]
    let weathers = ["Clear", "Overcast", "Rain", "Wind"]

    var body: some View {
        ZStack {
            AnimatedBackgroundSX()
            ScrollView(showsIndicators: false) {
                VStack(spacing: adaptyH(22)) {
                    heroHeader
                    horseSelector
                    trackSelector
                    weatherSelector
                    intensitySlider
                    runButton
                    if let result = viewModel.simulatorResult {
                        resultCard(result: result)
                    }
                    Spacer().frame(height: adaptyH(100))
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
            }
        }
        .navigationTitle("Training Simulator")
        .navigationBarTitleDisplayMode(.inline)
    }

    var heroHeader: some View {
        GlowingCardSX(glowColor: ColorSX.positive) {
            HStack(spacing: 14) {
                Image(systemName: "speedometer")
                    .font(.system(size: 32))
                    .foregroundStyle(ColorSX.positive)
                    .glowEffect(ColorSX.positive, radius: 10)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Training Simulator")
                        .font(FontSX.headline(18))
                        .foregroundStyle(ColorSX.textPrimary)
                    Text("Configure your session and calculate training effectiveness.")
                        .font(FontSX.body(13))
                        .foregroundStyle(ColorSX.textMuted)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }

    var horseSelector: some View {
        selectorSection(title: "Horse Breed", icon: "hare.fill", color: ColorSX.accentGold) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(horses, id: \.self) { h in
                        Button {
                            withAnimation { viewModel.simulatorHorse = h }
                        } label: {
                            Text(h)
                                .font(FontSX.label(13))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(Capsule().fill(viewModel.simulatorHorse == h ? ColorSX.accentGold : ColorSX.surface))
                                .foregroundStyle(viewModel.simulatorHorse == h ? .black : ColorSX.textSecondary)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    var trackSelector: some View {
        selectorSection(title: "Track Type", icon: "road.lanes", color: ColorSX.glowBlue) {
            HStack{
                ForEach(tracks, id: \.self) { t in
                    Spacer()
                    Button {
                        withAnimation { viewModel.simulatorTrack = t }
                    } label: {
                        Text(t)
                            .font(FontSX.label(13))
                            .lineLimit(1)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(Capsule().fill(viewModel.simulatorTrack == t ? ColorSX.glowBlue : ColorSX.surface))
                            .foregroundStyle(viewModel.simulatorTrack == t ? .white : ColorSX.textSecondary)
                    }
                    .buttonStyle(.plain)
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
        }
    }

    var weatherSelector: some View {
        selectorSection(title: "Weather", icon: "cloud.sun.fill", color: ColorSX.glowPurple) {
            HStack(spacing: 10) {
                ForEach(weathers, id: \.self) { w in
                    Button {
                        withAnimation { viewModel.simulatorWeather = w }
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: weatherIcon(w))
                                .font(.system(size: 16))
                                .foregroundStyle(viewModel.simulatorWeather == w ? .white : ColorSX.textMuted)
                            Text(w)
                                .font(FontSX.caption(11))
                                .foregroundStyle(viewModel.simulatorWeather == w ? .white : ColorSX.textMuted)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(viewModel.simulatorWeather == w ? ColorSX.glowPurple : ColorSX.surface)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }

    var intensitySlider: some View {
        selectorSection(title: "Training Intensity", icon: "flame.fill", color: ColorSX.glowOrange) {
            VStack(spacing: 10) {
                HStack {
                    Text("Low")
                        .font(FontSX.caption(12))
                        .foregroundStyle(ColorSX.textMuted)
                    Slider(value: Bindable(viewModel).simulatorIntensity, in: 0.1...1.0)
                        .tint(ColorSX.glowOrange)
                    Text("Max")
                        .font(FontSX.caption(12))
                        .foregroundStyle(ColorSX.textMuted)
                }
                Text("\(Int(viewModel.simulatorIntensity * 100))% Intensity")
                    .font(FontSX.label(14))
                    .foregroundStyle(ColorSX.glowOrange)
            }
        }
    }

    var runButton: some View {
        Button {
            withAnimation { viewModel.runSimulator() }
        } label: {
            HStack {
                Image(systemName: "play.fill")
                Text("Run Simulation")
            }
            .font(FontSX.label(17))
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .frame(height: adaptyH(54))
            .background(GradientSX.gold)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: ColorSX.accentGold.opacity(0.4), radius: 12, y: 4)
        }
    }

    func resultCard(result: Double) -> some View {
        GlowingCardSX(glowColor: resultColor(result)) {
            VStack(spacing: 16) {
                Text("Training Effectiveness")
                    .font(FontSX.label(14))
                    .foregroundStyle(ColorSX.textMuted)
                Text("\(Int(result))%")
                    .font(.system(size: 56, weight: .black, design: .rounded))
                    .foregroundStyle(resultColor(result))
                    .glowEffect(resultColor(result), radius: 16)
                Text(resultLabel(result))
                    .font(FontSX.headline(16))
                    .foregroundStyle(ColorSX.textPrimary)
                VStack(spacing: 10) {
                    HorseStatBarSX(label: "Effectiveness", value: Int(result), max: 100, color: resultColor(result))
                }
                Button {
                    let session = TrainingSessionSX(
                        sessionId: UUID().uuidString,
                        horse: viewModel.simulatorHorse,
                        trackType: viewModel.simulatorTrack,
                        weather: viewModel.simulatorWeather,
                        intensity: Int(viewModel.simulatorIntensity * 100),
                        effectivenessScore: result
                    )
                    ctx.insert(session)
                } label: {
                    Label("Save Session", systemImage: "square.and.arrow.down")
                        .font(FontSX.label(14))
                        .foregroundStyle(ColorSX.accent)
                }
            }
        }
    }

    func resultColor(_ v: Double) -> Color {
        switch v {
        case 80...: return ColorSX.positive
        case 60..<80: return ColorSX.warning
        default: return ColorSX.danger
        }
    }

    func resultLabel(_ v: Double) -> String {
        switch v {
        case 85...: return "Outstanding — Peak Training Response"
        case 70..<85: return "Excellent — Strong Adaptation Signal"
        case 55..<70: return "Good — Solid Base Building"
        default: return "Below Optimal — Adjust Parameters"
        }
    }

    func weatherIcon(_ w: String) -> String {
        switch w {
        case "Clear": return "sun.max.fill"
        case "Overcast": return "cloud.fill"
        case "Rain": return "cloud.rain.fill"
        default: return "wind"
        }
    }

    func selectorSection<Content: View>(title: String, icon: String, color: Color, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon).foregroundStyle(color).font(.system(size: 14))
                Text(title).font(FontSX.label(14)).foregroundStyle(ColorSX.textPrimary)
            }
            content()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(GradientSX.card)
                .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).strokeBorder(color.opacity(0.2), lineWidth: 1))
        )
    }
}

#Preview {
    NavigationStack {
        TrainingSimulatorViewSX().environment(MainViewModelSX())
    }
    .modelContainer(for: TrainingSessionSX.self, inMemory: true)
}
