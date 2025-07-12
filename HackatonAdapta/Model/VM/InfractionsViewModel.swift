//
//  InteractionsViewModel.swift
//  HackatonAdapta
//
//  Created by Hannah Goldstein on 12/07/25.
//

import SwiftUI

@MainActor
class InfractionsViewModel: ObservableObject {
    @Published var enviosComInfracoes: [(Envio, [Infracao])] = []

    func carregarEnviosComInfracoes() async {
        let userID = "demo_user"
        let envios = await FirestoreManager.shared.fetchEnviosDoUsuario(userID: userID)
        
        var resultado: [(Envio, [Infracao])] = []
        for envio in envios {
            let infracoes = await FirestoreManager.shared.fetchInfracoesParaEnvio(envioID: envio.id)
            resultado.append((envio, infracoes))
        }

        self.enviosComInfracoes = resultado
    }
}
