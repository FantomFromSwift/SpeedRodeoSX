import SwiftUI

struct CustomTabBarSX: View {
    @Binding var selectedTab: TabSX
    @Namespace private var animNS

    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabSX.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                } label: {
                    VStack(spacing: 4) {
                        ZStack {
                            if selectedTab == tab {
                                Capsule()
                                    .fill(ColorSX.accent.opacity(0.18))
                                    .frame(width: adaptyW(44), height: adaptyH(30))
                                    .matchedGeometryEffect(id: "TAB_PILL", in: animNS)
                            }
                            Image(systemName: tab.icon)
                                .font(.system(size: 18, weight: selectedTab == tab ? .bold : .regular))
                                .foregroundStyle(selectedTab == tab ? ColorSX.accent : ColorSX.textMuted)
                                .scaleEffect(selectedTab == tab ? 1.15 : 1.0)
                                .shadow(color: selectedTab == tab ? ColorSX.accent.opacity(0.6) : .clear, radius: 6)
                        }
                        Text(tab.rawValue)
                            .font(.system(size: 10, weight: selectedTab == tab ? .semibold : .regular, design: .rounded))
                            .foregroundStyle(selectedTab == tab ? ColorSX.accent : ColorSX.textMuted)
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 12)
        .padding(.bottom, max(UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first?.safeAreaInsets.bottom ?? 0, 16))
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .overlay(alignment: .top) {
                    Rectangle()
                        .fill(ColorSX.accent.opacity(0.15))
                        .frame(height: 1)
                }
                .ignoresSafeArea(edges: .bottom)
        )
    }
}
