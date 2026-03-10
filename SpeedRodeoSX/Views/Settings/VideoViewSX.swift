import SwiftUI

struct VideoViewSX: View {
    @State private var isPlaying = false
    @State private var progress: Double = 0
    @State private var timer: Timer? = nil
    @State private var selectedVideoURL: String? = nil

    let videoTopics = VideoTopicSX.all

    var body: some View {
        ZStack {
            AnimatedBackgroundSX()
            ScrollView(showsIndicators: false) {
                VStack(spacing: adaptyH(22)) {
                    Text("Educational Guides")
                        .font(FontSX.display(24))
                        .foregroundStyle(GradientSX.goldText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ForEach(videoTopics) { topic in
                        Button {
                            selectedVideoURL = topic.videoURL
                        } label: {
                            videoTopicCard(topic: topic)
                        }
                        .buttonStyle(.plain)
                    }
                    Spacer().frame(height: adaptyH(100))
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
        }
        .navigationTitle("Tutorials")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedVideoURL) { url in
            SwiftUIWebViewSX(urlString: url)
        }
        .onDisappear { timer?.invalidate() }
    }
    
    func startProgress() {
        progress = 0
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { t in
            progress = min(progress + 0.005, 1.0)
            if progress >= 1.0 {
                t.invalidate()
                isPlaying = false
                progress = 0
            }
        }
    }

    func videoTopicCard(topic: VideoTopicSX) -> some View {
        GlowingCardSX(glowColor: topic.color, padding: 16) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(topic.color.opacity(0.12))
                        .frame(width: adaptyW(54), height: adaptyH(42))
                    Image(systemName: topic.icon)
                        .font(.system(size: 20))
                        .foregroundStyle(topic.color)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(topic.title)
                        .font(FontSX.headline(15))
                        .foregroundStyle(ColorSX.textPrimary)
                        .lineLimit(2)
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 10))
                        Text(topic.duration)
                            .font(FontSX.caption(12))
                    }
                    .foregroundStyle(ColorSX.textMuted)
                }
                Spacer()
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(topic.color.opacity(0.8))
            }
        }
    }
}

extension String: @retroactive Identifiable {
    public var id: String { self }
}

struct VideoTopicSX: Identifiable {
    let id: String
    let title: String
    let duration: String
    let icon: String
    let color: Color
    let videoURL: String

    static let all: [VideoTopicSX] = [
        VideoTopicSX(id: "v1", title: "Introduction to Flat Racing", duration: "16:19 min", icon: "flag.checkered", color: ColorSX.danger, videoURL: "https://www.youtube.com/watch?v=_5lZAQNbNfw"),
        VideoTopicSX(id: "v2", title: "How to ride a horse", duration: "7:30 min", icon: "figure.equestrian.sports", color: ColorSX.glowOrange, videoURL: "https://www.youtube.com/watch?v=jByGqv0Wt-Q"),
        VideoTopicSX(id: "v3", title: "25 Horse Racing Terms You Should Know", duration: "18:46 min", icon: "road.lanes", color: ColorSX.glowBlue, videoURL: "https://www.youtube.com/watch?v=KSUDDfoAXeY"),
        VideoTopicSX(id: "v4", title: "Ruth Carr: Training racehorses with a difference", duration: "30 min", icon: "heart.fill", color: ColorSX.positive, videoURL: "https://www.youtube.com/watch?v=KXjmMal17CA"),
        VideoTopicSX(id: "v5", title: "HOW TO CARE FOR A HORSE (Complete Guide)", duration: "16:29 min", icon: "house.fill", color: ColorSX.glowPurple, videoURL: "https://www.youtube.com/watch?v=zI8JSTGtRQc&t=34s"),
        VideoTopicSX(id: "v6", title: "The Horse’s Cardiovascular and Respiratory Systems", duration: "20:42 min", icon: "waveform.path.ecg", color: ColorSX.accentGold, videoURL: "https://www.youtube.com/watch?v=jA4ePaaYRQY")
    ]
}


#Preview {
    NavigationStack { VideoViewSX() }
}
