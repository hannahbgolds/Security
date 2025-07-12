//
//  VideoUploadManager.swift
//  HackatonAdapta
//
//  Created by Hannah Goldstein on 12/07/25.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseStorage

class VideoUploadManager {
    private let storage = Storage.storage()

    func uploadVideo(fileURL: URL, userID: String) async -> String? {
        let videoID = UUID().uuidString
        let storageRef = storage.reference().child("videos/\(userID)/\(videoID).mov")

        do {
            let _ = try await storageRef.putFileAsync(from: fileURL)
            let downloadURL = try await storageRef.downloadURL()
            print("✅ Vídeo enviado com sucesso: \(downloadURL.absoluteString)")
            return downloadURL.absoluteString
        } catch {
            print("❌ Erro ao enviar vídeo: \(error.localizedDescription)")
            return nil
        }
    }
}

