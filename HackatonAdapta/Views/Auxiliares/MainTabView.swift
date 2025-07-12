import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var showCamera = false

    var body: some View {
        TabView(selection: $selectedTab) {
            InfractionView()
                .tabItem {
                    Label("Infrações", systemImage: "list.bullet")
                }
                .tag(0)

            
            Color.clear
                .tabItem {
                    Label("Câmera", systemImage: "camera")
                }
                .tag(1)

            Text("Chat")
                .tabItem {
                    Label("Chat", systemImage: "bubble.left")
                }
                .tag(2)
        }
        .onChange(of: selectedTab) {
            if selectedTab == 1 {
                showCamera = true
            }
        }
        .sheet(isPresented: $showCamera, onDismiss: {
            selectedTab = 0
        }) {
            VideoCaptureView()
        }
    }
}

#Preview {
    MainTabView()
}




