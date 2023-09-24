//
//  Location.swift
//  Bucketlist
//
//  Created by Mathieu Dubart on 24/09/2023.
//

import CoreLocation
import Foundation

struct Location: Identifiable, Codable, Equatable {
    var id: UUID
    var name: String
    var description: String
    
    // ----- CLLocationCoordinated2d() doesn't conform to Codable so we use doubles to be able to store them
    let latitude: Double
    let longitude: Double
    
    var coordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static let example = Location(id: UUID(), name: "Buckingham Palace", description: "Where Queen Elizabeth lives with her dorgis", latitude: 51.501, longitude: -0.141)
    
    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}
