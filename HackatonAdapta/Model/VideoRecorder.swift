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
//            let firestore = FirestoreManager.shared
            let userID = "demo_user" //MARK: Substituir
            let videoDate = Date()
            let location = await locationManager.getLocation()

            if let videoURL = await uploader.uploadVideo(fileURL: outputFileURL, userID: userID) {
                // ✅ (1) Criar o JSON com os dados
                let locationDict: [String: Double]? = {
                    guard let loc = location else { return nil }
                    return ["latitude": loc.latitude, "longitude": loc.longitude]
                }()
                
                let payload: [String: Any] = [
                    "userID": userID,
                    "videoURL": videoURL,
                    "date": ISO8601DateFormatter().string(from: videoDate),
                    "location": locationDict as Any // aqui é opcional, pode ser nil
                ]
                
                print("***********************")
                print(payload)
                print("***********************")

                // ✅ (2) Serializar o JSON
                guard let jsonData = try? JSONSerialization.data(withJSONObject: payload) else {
                    print("Erro ao converter dados para JSON")
                    return
                }

                // ✅ (3) Criar a requisição
                guard let url = URL(string: "http://169.254.226.169:4000/exemplo") else {
                    print("URL inválida")
                    return
                }

                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = jsonData

                // ✅ (4) Fazer a requisição
                do {
                    let (data, response) = try await URLSession.shared.data(for: request)

                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                        print("Envio registrado com sucesso na API")
                    } else {
                        print("Erro na resposta da API")
                        print(String(data: data, encoding: .utf8) ?? "Sem corpo de resposta")
                    }
                } catch {
                    print("Erro ao fazer requisição para a API: \(error)")
                }
            }
        }

    }
}
