//
//  FirestoreManager.swift
//  HackatonAdapta
//
//  Created by Hannah Goldstein on 12/07/25.
//

import Foundation
import FirebaseFirestore
import CoreLocation

@Observable
class FirestoreManager {
    
    static let shared = FirestoreManager()
    private init() {}
    
    private let db = Firestore.firestore()
    private let videosCollection = "Videos"

    /// Salva os metadados de um vídeo no Firestore
    func saveVideoMetadata(userID: String, videoURL: String, date: Date, location: CLLocationCoordinate2D?) async {
        var data: [String: Any] = [
            "userID": userID,
            "videoURL": videoURL,
            "timestamp": Timestamp(date: date)
        ]

        if let location = location {
            data["location"] = [
                "latitude": location.latitude,
                "longitude": location.longitude
            ]
        }

        do {
            try await db.collection(videosCollection).addDocument(data: data)
            print("✅ Metadados salvos no Firestore")
        } catch {
            print("❌ Erro ao salvar no Firestore: \(error.localizedDescription)")
        }
    }
}


