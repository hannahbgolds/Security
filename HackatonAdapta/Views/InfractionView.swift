//
//  InfractionView.swift
//  HackatonAdapta
//
//  Created by Hannah Goldstein on 12/07/25.
//

import SwiftUI

struct InfractionView: View {
    @StateObject private var viewModel = InfractionsViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.enviosComInfracoes, id: \.0.id) { envio, infracoes in
                        EnvioCard(envio: envio, infracoes: infracoes)
                    }
                }
                .padding()
            }
            .navigationTitle("Infrações Enviadas")
            .task {
                await viewModel.carregarEnviosComInfracoes()
            }
        }
    }
}

struct EnvioCard: View {
    let envio: Envio
    let infracoes: [Infracao]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("📍 Localização:")
                    .font(.caption.bold())
                if let lat = envio.latitude, let lon = envio.longitude {
                    Text("\(lat), \(lon)")
                } else {
                    Text("Desconhecida")
                }
            }

            HStack {
                Text(envio.timestamp, style: .date)
                Spacer()
                Text("Status: \(envio.status.capitalized)")
                    .bold()
            }

            if !infracoes.isEmpty {
                Text("Possíveis Infrações")
                    .bold()

                ForEach(infracoes) { infracao in
                    Text("• \(infracao.descricao)")
                }
            } else {
                Text("Sem infrações associadas")
                    .italic()
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
}
