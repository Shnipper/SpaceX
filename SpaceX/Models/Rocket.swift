import Foundation

struct Rocket: Codable {
    
    let name: String
    let flickrImages: [String]

    let height: Length
    let diameter: Length
    let mass: Mass
    let payloadWeights: [PayloadWeight]

    let firstFlight: String
    let country: String
    let costPerLaunch: Int
    let firstStage: Stage
    let secondStage: Stage
    
    let id: String
}

struct PayloadWeight: Codable {
    
    let id: String
    let kg: Int
    let lb: Int
}

struct Length: Codable {
    
    let meters: Double?
    let feet: Double?
}

struct Mass: Codable {
    
    let kg: Int
    let lb: Int
}

struct Stage: Codable {
    
    let engines: Int
    let fuelAmountTons: Double
    let burnTimeSec: Int?
}
