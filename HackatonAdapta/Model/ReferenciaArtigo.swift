import Foundation

struct ReferenciaArtigo: Codable {
    var lawReference: String
    var score: Double
    var ticket: String

    init?(from data: [String: Any]) {
        guard
            let lawReference = data["law_reference"] as? String,
            let score = data["score"] as? Double,
            let ticket = data["ticket"] as? String
        else {
            return nil
        }

        self.lawReference = lawReference
        self.score = score
        self.ticket = ticket
    }
    
    enum CodingKeys: String, CodingKey {
        case lawReference = "law_reference"
        case score
        case ticket
    }
}
