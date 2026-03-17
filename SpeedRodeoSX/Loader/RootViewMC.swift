import SwiftUI

struct RootViewMC: View {
    @EnvironmentObject private var vm: LoaderViewModel
    @State private var showSplash = true
    @State private var didRunConsentThisLaunch = false
    
    var body: some View {
        ZStack {
            switch vm.presented {
                
            case .splash:
                SplashViewSX {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showSplash = false
                    }
                }
                .transition(.opacity)
                .zIndex(10)
                .onAppear {
                    guard !didRunConsentThisLaunch else { return }
                    didRunConsentThisLaunch = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        ATTManager.shared.requestTrackingIfNeeded { _ in
                            
                            PushManager.shared.requestPush { _ in
                                Task { @MainActor in
                                    vm.onPushAnswered()
                                }
                            }
                        }
                    }
                }
                
            case .main:
                MainViewSX()
                
            case .changed:
                LoaderPageView(loaderViewModel: vm, url: vm.mailLink ?? vm.link)
                    .onAppear {
                        AppDelegate.orientationLock = [.portrait, .landscapeLeft, .landscapeRight]
                    }
            }
        }
    }
}
