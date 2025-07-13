import Foundation

struct Infracao: Codable {
    var comportamentoObservado: String
    var cor: String
    var modelo: String
    var placa: String
    var possivelInfracao: String
    var referencias: [ReferenciaArtigo]

    init?(from data: [String: Any]) {
        guard
            let comportamento = data["Comportamento observado"] as? String,
            let cor = data["Cor"] as? String,
            let modelo = data["Modelo"] as? String,
            let placa = data["Placa"] as? String,
            let possivelInfracao = data["Possível infração"] as? String
        else {
            return nil
        }

        self.comportamentoObservado = comportamento
        self.cor = cor
        self.modelo = modelo
        self.placa = placa
        self.possivelInfracao = possivelInfracao

        if let refs = data["law_references"] as? [[String: Any]] {
            self.referencias = refs.compactMap { ReferenciaArtigo(from: $0) }
        } else {
            self.referencias = []
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case comportamentoObservado = "Comportamento observado"
        case cor = "Cor"
        case modelo = "Modelo"
        case placa = "Placa"
        case possivelInfracao = "Possível infração"
        case referencias = "law_references"
    }
}
