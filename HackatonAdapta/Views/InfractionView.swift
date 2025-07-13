//
//  InfractionView.swift
//  HackatonAdapta
//
//  Created by Hannah Goldstein on 12/07/25.
//

import SwiftUI
import CoreLocation

struct InfractionView: View {
    @State var envios: [Envio] = []

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(envios, id: \.videoURL) { envio in
                        EnvioCard(envio: envio)
                    }
                }
                .padding()
            }
            .navigationTitle("Infrações Enviadas")
            .task {
                envios = await FirestoreManager.shared.getAllEnvios()
                print("Envios: \(envios)")
            }
        }
    }
}

struct EnvioCard: View {
    let envio: Envio
    
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
                Text(envio.date, style: .date)
                Spacer()
                Text("Status: \(envio.status.capitalized)")
                    .bold()
            }
            
            if let infracoes = envio.infracao {
                Text("Possíveis Infrações")
                    .bold()
                
                ForEach(infracoes.referencias, id:\.lawReference) { infracao in
                    Text("• \(infracao.ticket)")
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
