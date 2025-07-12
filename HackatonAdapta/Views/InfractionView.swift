//
//  InfractionView.swift
//  HackatonAdapta
//
//  Created by Hannah Goldstein on 12/07/25.
//

import SwiftUI
import CoreLocation

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
    
    @State private var endereco: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("📍 Localização:")
                    .font(.caption.bold())
                
                if let endereco = endereco {
                    Text(endereco)
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else if envio.latitude != nil && envio.longitude != nil {
                    Text("Carregando endereço...")
                        .italic()
                        .font(.caption)
                } else {
                    Text("Desconhecida")
                        .font(.caption)
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
        .onAppear {
            if let lat = envio.latitude, let lon = envio.longitude {
                let location = CLLocation(latitude: lat, longitude: lon)
                obterEndereco(from: location) { resultado in
                    endereco = resultado ?? "Endereço não encontrado"
                }
            }
        }
    }
}
