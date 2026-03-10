import SwiftUI
import WebKit

struct WebViewSX: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.backgroundColor = .clear
        webView.isOpaque = false
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

struct SwiftUIWebViewSX: View {
    let urlString: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(ColorSX.textMuted)
                }
                .padding()
            }
            .background(ColorSX.surface)
            
            if let url = URL(string: urlString) {
                WebViewSX(url: url)
            } else {
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundStyle(ColorSX.danger)
                    Text("Invalid Video URL")
                        .font(FontSX.headline(18))
                        .foregroundStyle(ColorSX.textPrimary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(ColorSX.background)
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}
