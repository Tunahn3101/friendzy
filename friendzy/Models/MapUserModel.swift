import Foundation
import MapKit

struct MapUserModel: Identifiable, Equatable, Hashable {
    let id: UUID
    var name: String
    var age: Int
    var avatarURL: String
    var interests: [String]
    var coordinate: CLLocationCoordinate2D
    var distance: Int
    
    init(id: UUID = UUID(), name: String, age: Int, avatarURL: String, interests: [String], latitude: Double, longitude: Double, distance: Int) {
        self.id = id
        self.name = name
        self.age = age
        self.avatarURL = avatarURL
        self.interests = interests
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.distance = distance
    }
    
    static func == (lhs: MapUserModel, rhs: MapUserModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

let sampleMapUsers: [MapUserModel] = [
    MapUserModel(name: "Emma", age: 24, avatarURL: "ava_vanessa", interests: ["Travel", "Photography", "Music"], latitude: 52.5200, longitude: 13.4050, distance: 2),
    MapUserModel(name: "Sophie", age: 26, avatarURL: "ava_halima", interests: ["Fitness", "Nature", "Sports"], latitude: 52.5150, longitude: 13.3900, distance: 3),
    MapUserModel(name: "Mia", age: 23, avatarURL: "ava_vanessa", interests: ["Art", "Reading", "Coffee"], latitude: 52.5300, longitude: 13.4200, distance: 4),
    MapUserModel(name: "Laura", age: 25, avatarURL: "ava_halima", interests: ["Travel", "Cooking", "Fashion"], latitude: 52.5100, longitude: 13.4100, distance: 5),
    MapUserModel(name: "Anna", age: 27, avatarURL: "ava_vanessa", interests: ["Gaming", "Technology", "Movies"], latitude: 52.5250, longitude: 13.3950, distance: 3),
    MapUserModel(name: "Lisa", age: 24, avatarURL: "ava_halima", interests: ["Dance", "Music", "Fitness"], latitude: 52.5180, longitude: 13.4150, distance: 4),
    MapUserModel(name: "Julia", age: 26, avatarURL: "ava_vanessa", interests: ["Pets", "Nature", "Photography"], latitude: 52.5220, longitude: 13.4000, distance: 2),
    MapUserModel(name: "Lena", age: 25, avatarURL: "ava_halima", interests: ["Reading", "Coffee", "Art"], latitude: 52.5280, longitude: 13.4080, distance: 5),
    MapUserModel(name: "Nina", age: 23, avatarURL: "ava_vanessa", interests: ["Travel", "Sports", "Music"], latitude: 52.5140, longitude: 13.4120, distance: 3),
    MapUserModel(name: "Sara", age: 28, avatarURL: "ava_halima", interests: ["Fashion", "Photography", "Coffee"], latitude: 52.5190, longitude: 13.3980, distance: 4)
]
