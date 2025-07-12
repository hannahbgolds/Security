//
//  Infraction.swift
//  HackatonAdapta
//
//  Created by Hannah Goldstein on 12/07/25.
//

import Foundation
import FirebaseFirestore

struct Infracao: Identifiable {
    let id: String
    let artigo: Int
    let descricao: String
    let dataAnalise: Date?
    let envioRef: DocumentReference

    init?(from document: DocumentSnapshot) {
        let data = document.data()
        guard
            let artigo = data?["artigo"] as? Int,
            let descricao = data?["descricao"] as? String,
            let envioRef = data?["envioRef"] as? DocumentReference
        else {
            return nil
        }

        self.id = document.documentID
        self.artigo = artigo
        self.descricao = descricao
        self.envioRef = envioRef
        self.dataAnalise = (data?["dataAnalise"] as? Timestamp)?.dateValue()
    }
}
