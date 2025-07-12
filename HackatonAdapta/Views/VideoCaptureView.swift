//
//  VideoCaptureView.swift
//  HackatonAdapta
//
//  Created by Hannah Goldstein on 12/07/25.
//

import SwiftUI
import AVFoundation
import CoreLocation

struct VideoCaptureView: View {
    @StateObject private var recorder = VideoRecorder()
    @ObservedObject var locationManager = LocationManager()

    var body: some View {
        ZStack {
            CameraPreview(session: recorder.captureSession)
                .ignoresSafeArea()

            VStack {
                Spacer()

                if let date = recorder.lastRecordingDate {
                    Text("Data/Hora: \(date.formatted(date: .abbreviated, time: .standard))")
                        .foregroundColor(.white)
                }

                if let location = locationManager.lastKnownLocation {
                    Text("Localização: \(location.latitude), \(location.longitude)")
                        .foregroundColor(.white)
                }

                Button(action: {
                    if recorder.isRecording {
                        recorder.stopRecording()
                    } else {
                        recorder.startRecording()
                        locationManager.requestLocation()
                    }
                }) {
                    Circle()
                        .fill(recorder.isRecording ? .red : .white)
                        .frame(width: 70, height: 70)
                        .overlay(Circle().stroke(Color.black, lineWidth: 2))
                        .padding()
                }
            }
        }
        .onAppear {
            recorder.setup()
        }
    }
}

// Preview da câmera
struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = UIScreen.main.bounds
        view.layer.addSublayer(previewLayer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
