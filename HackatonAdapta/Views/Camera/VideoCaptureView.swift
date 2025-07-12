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
    @Environment(\.dismiss) private var dismiss
    @StateObject private var recorder = VideoRecorder()
    @ObservedObject var locationManager = LocationManager()
    @State private var flashOn = false

    var body: some View {
        ZStack {
            CameraPreview(session: recorder.captureSession)
                .ignoresSafeArea()

            VStack {
                HStack {
                    // Flash toggle
                    Button(action: toggleFlash) {
                        Image(systemName: flashOn ? "bolt.fill" : "bolt.slash")
                            .font(.title2)
                            .foregroundColor(.yellow)
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    Spacer()

                    // Dismiss button
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
                .padding(.top, 30)

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

    private func toggleFlash() {
        flashOn.toggle()
        recorder.setFlash(enabled: flashOn)
    }
}


