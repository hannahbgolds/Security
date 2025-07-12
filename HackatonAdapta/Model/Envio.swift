//
//  Envio.swift
//  HackatonAdapta
//
//  Created by Hannah Goldstein on 12/07/25.
//

import Foundation
import FirebaseFirestore

struct Envio: Identifiable {
    let id: String
    let userID: String
    let videoURL: String
    let timestamp: Date
    let status: String
    let latitude: Double?
    let longitude: Double?

    init?(from document: DocumentSnapshot) {
        let data = document.data()
        guard
            let userID = data?["userID"] as? String,
            let videoURL = data?["videoURL"] as? String,
            let timestamp = data?["timestamp"] as? Timestamp,
            let status = data?["status"] as? String
        else {
            return nil
        }

        self.id = document.documentID
        self.userID = userID
        self.videoURL = videoURL
        self.timestamp = timestamp.dateValue()
        self.status = status

        if let location = data?["location"] as? [String: Any] {
            self.latitude = location["latitude"] as? Double
            self.longitude = location["longitude"] as? Double
        } else {
            self.latitude = nil
            self.longitude = nil
        }
    }
}
