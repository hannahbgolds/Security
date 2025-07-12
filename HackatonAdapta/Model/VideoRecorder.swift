//
//  VideoRecorder.swift
//  HackatonAdapta
//
//  Created by Hannah Goldstein on 12/07/25.
//

import AVFoundation
import Photos

class VideoRecorder: NSObject, ObservableObject, AVCaptureFileOutputRecordingDelegate {
    let captureSession = AVCaptureSession()
    private let movieOutput = AVCaptureMovieFileOutput()

    @Published var isRecording = false
    @Published var lastRecordingDate: Date?
    @Published var locationManager = LocationManager()
    

    func setup() {
        captureSession.beginConfiguration()

        guard
            let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
            let audioDevice = AVCaptureDevice.default(for: .audio),
            let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
            let audioInput = try? AVCaptureDeviceInput(device: audioDevice)
        else {
            print("Erro ao configurar inputs")
            return
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }
        if captureSession.canAddInput(audioInput) {
            captureSession.addInput(audioInput)
        }
        if captureSession.canAddOutput(movieOutput) {
            captureSession.addOutput(movieOutput)
        }

        captureSession.commitConfiguration()

         DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }


    func startRecording() {
        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(UUID().uuidString).mov")
        movieOutput.startRecording(to: outputURL, recordingDelegate: self)
        lastRecordingDate = Date()
        isRecording = true
    }

    func stopRecording() {
        movieOutput.stopRecording()
    }
    
    func setFlash(enabled: Bool) {
        guard let device = AVCaptureDevice.default(for: .video),
              device.hasTorch else { return }

        do {
            try device.lockForConfiguration()
            device.torchMode = enabled ? .on : .off
            device.unlockForConfiguration()
        } catch {
            print("❌ Erro ao configurar o flash: \(error.localizedDescription)")
        }
    }


    // MARK: - Delegate
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL,
                    from connections: [AVCaptureConnection], error: Error?) {
        isRecording = false

        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                PHPhotoLibrary.shared().performChanges {
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
                } completionHandler: { success, error in
                    if let error = error {
                        print("Erro ao salvar vídeo: \(error.localizedDescription)")
                    }
                }
            }
        }

        Task {
            let uploader = VideoUploadManager()
            let firestore = FirestoreManager.shared
            let userID = "demo_user" //MARK: Substituir 
            let videoDate = Date()
            let location = await locationManager.getLocation()

            if let videoURL = await uploader.uploadVideo(fileURL: outputFileURL, userID: userID) {
                _ = await firestore.saveEnvio(
                    userID: userID,
                    videoURL: videoURL,
                    date: videoDate,
                    location: location
                )
            }
        }
    }
}
