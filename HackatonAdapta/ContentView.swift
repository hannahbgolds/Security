//
//  ContentView.swift
//  HackatonAdapta
//
//  Created by Hannah Goldstein on 12/07/25.
//

import SwiftUI
import UIKit
import CoreLocation

struct ContentView: View {
    @State private var showCamera = false
    @State private var image: UIImage?
    @State private var dateTime: Date?
    @State private var location: CLLocationCoordinate2D?
    
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        VStack(spacing: 20) {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            }

            if let dateTime = dateTime {
                Text("Data/Hora: \(dateTime.formatted(.dateTime))")
            }

            if let location = location {
                Text("Localização: \(location.latitude), \(location.longitude)")
            }

            Button {
                locationManager.requestLocation()
                showCamera = true
            } label: {
                Label("Tirar Foto", systemImage: "camera")
                    .font(.title)
            }
            .sheet(isPresented: $showCamera) {
                ImagePicker(image: $image, onImagePicked: {
                    dateTime = Date()
                    location = locationManager.lastKnownLocation
                })
            }
        }
        .padding()
    }
}

// MARK: - UIImagePickerController Wrapper
struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    @Binding var image: UIImage?
    var onImagePicked: () -> Void

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
                parent.onImagePicked()
            }
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

// MARK: - Location Manager
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var lastKnownLocation: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
    }

    func requestLocation() {
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Erro ao obter localização: \(error)")
    }
}

#Preview {
    ContentView()
}
