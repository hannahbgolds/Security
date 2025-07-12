//
//  CamerView.swift
//  HackatonAdapta
//
//  Created by Hannah Goldstein on 12/07/25.
//

import SwiftUI

struct CameraView: View {
    @State private var showVideoRecorder = false

    var body: some View {
        VStack {
            Spacer()

            Button {
                showVideoRecorder = true
            } label: {
                Image(systemName: "camera")
                    .resizable()
                    .frame(width: 40, height: 30)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Circle())
            }

            Spacer()
        }
        .sheet(isPresented: $showVideoRecorder) {
            VideoCaptureView()
        }
    }
}

#Preview{
    
}
