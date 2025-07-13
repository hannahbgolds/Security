import Foundation
import FirebaseFirestore

struct Envio: Codable {
//    var id: String = UUID().uuidString
    var userID: String
    var videoURL: String
    var date: Date
    var status: String
    var latitude: Double?
    var longitude: Double?
    var infracao: Infracao?
    
    init?(from document: DocumentSnapshot) {
        let data = document.data()
        guard
            let userID = data?["userID"] as? String,
            let videoURL = data?["videoURL"] as? String,
            let timestamp = data?["date"] as? Timestamp,
            let status = data?["status"] as? String
        else {
            return nil
        }
        
        self.userID = userID
        self.videoURL = videoURL
        self.date = timestamp.dateValue()
        self.status = status
        
        if let location = data?["location"] as? [String: Any] {
            self.latitude = location["latitude"] as? Double
            self.longitude = location["longitude"] as? Double
        } else {
            self.latitude = nil
            self.longitude = nil
        }
        
        if let infracaoData = data?["infracao"] as? [String: Any] {
            self.infracao = Infracao(from: infracaoData)
        } else {
            self.infracao = nil
        }
    }
}
