//
//  HackatonAdaptaTests.swift
//  HackatonAdaptaTests
//
//  Created by Hannah Goldstein on 12/07/25.
//

import Testing
import AVFoundation

struct HackatonAdaptaTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        let payload: [String: Any] = [
            "userID": "exemplo",
            "videoURL": "exemplo",
            "date": ISO8601DateFormatter().string(from: Date()),
            "location": "Mengo"
        ]
        
        print("***********************")
        print(payload)
        print("***********************")

        // ✅ (2) Serializar o JSON
        guard let jsonData = try? JSONSerialization.data(withJSONObject: payload) else {
            print("Erro ao converter dados para JSON")
            return
        }

        // ✅ (3) Criar a requisição
        guard let url = URL(string: "http://10.49.48.49:4000/exemplo") else {
            print("URL inválida")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        // ✅ (4) Fazer a requisição
        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("Envio registrado com sucesso na API")
            } else {
                print("Erro na resposta da API")
                print(String(data: data, encoding: .utf8) ?? "Sem corpo de resposta")
            }
        } catch {
            print("Erro ao fazer requisição para a API: \(error)")
        }
        
//        #expect(true)
    }
    
    @Test func teste() async throws {
        guard let url = URL(string: "http://169.254.226.169:4000/exemplo") else {
            print("URL inválida")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = jsonData

        // ✅ (4) Fazer a requisição
        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("Envio registrado com sucesso na API")
            } else {
                print("Erro na resposta da API")
                print(String(data: data, encoding: .utf8) ?? "Sem corpo de resposta")
            }
        } catch {
            print("Erro ao fazer requisição para a API: \(error)")
        }
        
        #expect(true)
    }

}
