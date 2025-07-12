import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            // MARK: - Infrações
            InfractionView()
                .tabItem {
                    Label("Infrações", systemImage: "exclamationmark.triangle.fill")
                }

            // MARK: - Câmera
            CameraView()
                .tabItem {
                    Label("Câmera", systemImage: "camera.circle.fill")
                }

            // MARK: - Chat
            ChatView()
                .tabItem {
                    Label("Chat", systemImage: "message.fill")
                }
        }
        .tint(.red)
    }
}

#Preview {
    MainTabView()
}
