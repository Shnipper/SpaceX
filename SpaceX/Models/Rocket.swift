import Foundation

struct Rocket: Decodable {
    
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

struct PayloadWeight: Decodable {
    
    let id: String
    let kg: Int
    let lb: Int
}

struct Length: Decodable {
    
    let meters: Double?
    let feet: Double?
}

struct Mass: Decodable {
    
    let kg: Int
    let lb: Int
}

struct Stage: Decodable {
    
    let engines: Int
    let fuelAmountTons: Double
    let burnTimeSec: Int?
}
