//
//  ContentView-ViewModel.swift
//  Bucketlist
//
//  Created by Mathieu Dubart on 24/09/2023.
//

import Foundation
import LocalAuthentication
import MapKit

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0),
                                                      span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
        
        @Published private(set) var locations: Array<Location>
        @Published var selectedPlace: Location?
        @Published var isUnlocked = false
        @Published var authenticationError = "Unknown Error"
        @Published var isShowingAutenticationError = false
        
        let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPlaces")
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [NSData.WritingOptions.atomic, .completeFileProtection])
            } catch {
                print("Unabled to save data.")
            }
        }
        
        func setNewLocation() {
            let newLocation = Location(id: UUID(),
                                       name: "New location",
                                       description: "",
                                       latitude: mapRegion.center.latitude,
                                       longitude: mapRegion.center.longitude)
            
            locations.append(newLocation)
            save()
        }
        
        func updateLocation(with newLocation: Location) {
            guard let selectedPlace = selectedPlace else { return }
            
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = newLocation
                save()
            }
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places."
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    Task { @MainActor in
                        if success {
                            self.isUnlocked = true
                        } else {
                            // error
                            self.authenticationError = "Biometric authentication failed. Please try again."
                            self.isShowingAutenticationError = true
                        }
                    }
                }
            } else {
                // no biometrics
                authenticationError = "Sorry your device doesn't support biometric authentication"
                isShowingAutenticationError = true
            }
        }
    }
}
