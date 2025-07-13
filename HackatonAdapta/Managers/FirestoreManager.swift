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

    /// Salva um envio e retorna a referência do documento criado
    func saveEnvio(userID: String, videoURL: String, date: Date, location: CLLocationCoordinate2D?) async -> DocumentReference? {
        var envioData: [String: Any] = [
            "userID": userID,
            "videoURL": videoURL,
            "timestamp": Timestamp(date: date),
            "status": "pendente"
        ]

        if let location = location {
            envioData["location"] = [
                "latitude": location.latitude,
                "longitude": location.longitude
            ]
        }

        do {
            let ref = try await db.collection("Envios").addDocument(data: envioData)
            print("✅ Envio salvo com ID: \(ref.documentID)")
            return ref
        } catch {
            print("❌ Erro ao salvar envio: \(error.localizedDescription)")
            return nil
        }
    }

    // MARK: - Infração (Testes)
    /// Cria uma infração associada a um envio existente
    func saveInfraction(for envioRef: DocumentReference, artigo: Int, descricao: String) async {
        let infractionData: [String: Any] = [
            "artigo": artigo,
            "descricao": descricao,
            "dataAnalise": Timestamp(date: Date()),
            "envioRef": envioRef
        ]

        do {
            try await db.collection("Infracoes").addDocument(data: infractionData)
            try await envioRef.updateData(["status": "analisado"])
            print("✅ Infração salva e envio atualizado")
        } catch {
            print("❌ Erro ao salvar infração: \(error.localizedDescription)")
        }
    }

    /// Função de teste que cria uma infração ligada a um envio específico
    func testCriarInfracao() {
        let envioID = "oKyB2OrC3IuQ0DmsM6lp"
        let envioRef = db.collection("Envios").document(envioID)
        
        Task {
            await FirestoreManager.shared.saveInfraction(
                for: envioRef,
                artigo: 208,
                descricao: "Avanço de sinal"
            )
        }
    }
    
    
    func fetchEnviosDoUsuario(userID: String) async -> [Envio] {
        var envios: [Envio] = []

        do {
            let snapshot = try await db.collection("Envios")
                .whereField("userID", isEqualTo: userID)
                .order(by: "timestamp", descending: true)
                .getDocuments()

            for doc in snapshot.documents {
                let data = doc.data()
                let locationData = data["location"] as? [String: Double]

                if let envio = Envio(from: doc) {
                    envios.append(envio)
                }

            }

        } catch {
            print("❌ Erro ao buscar envios: \(error.localizedDescription)")
        }

        return envios
    }
    
    func getAllEnvios() async -> [Envio] {
        do {
            let querySnapshot = try await db.collection("Envios").getDocuments()
            var allEnvios: [Envio] = []
            
            for document in querySnapshot.documents {
                do {
                    // MARK: Tem forma melhor de fazer com certeza
                    let id = document.documentID
                    var apiResponse = try document.data(as: Envio.self)
//                    apiResponse.id = id
                    allEnvios.append(apiResponse)
                    return allEnvios
                } catch {
                    print("Failed to parse document data into Envio for document ID: \(document.documentID). Error: \(error)")
                    return []
                }
            }
        } catch {
            print("Error getting documents: \(error)")
        }
        return []
    }
}
