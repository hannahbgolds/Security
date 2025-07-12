//
//  obterEndereco.swift
//  HackatonAdapta
//
//  Created by Hannah Goldstein on 12/07/25.
//

import CoreLocation

func obterEndereco(from location: CLLocation, completion: @escaping (String?) -> Void) {
    let geocoder = CLGeocoder()
    geocoder.reverseGeocodeLocation(location) { placemarks, error in
        if let error = error {
            print("Erro no geocodificador: \(error.localizedDescription)")
            completion(nil)
            return
        }

        if let placemark = placemarks?.first {
            let endereco = [
                placemark.thoroughfare,      // Rua
                placemark.subThoroughfare,   // Número
                placemark.locality,          // Cidade
                placemark.administrativeArea // Estado
            ].compactMap { $0 }.joined(separator: ", ")

            completion(endereco)
        } else {
            completion(nil)
        }
    }
}
