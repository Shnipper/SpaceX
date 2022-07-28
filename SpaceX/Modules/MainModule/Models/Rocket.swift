import Foundation

struct Rocket: Decodable {
    
    /* JSON
     
     "name":            "Falcon 1"
     "flickr_images":   ["https://imgur.com/DaCfMsj.jpg","https://imgur.com/azYafd8.jpg"]
     "id":              "5e9d0d95eda69955f709d1eb"
     "height":          {"meters":22.25,
                        "feet":73}
     "diameter":        {"meters":1.68,
                        "feet":5.5}
     "mass":            {"kg":30146,
                        "lb":66460}
     "payload_weights": [{"id":"leo",
                        "name":"Low Earth Orbit",
                        "kg":450,"lb":992}]
     "country":         "Republic of the Marshall Islands"
     "first_flight":    "2006-03-24"
     "cost_per_launch": 6700000
     "first_stage":     {"engines":1,
                        "fuel_amount_tons":44.3,
                        "burn_time_sec":169}
     "second_stage":    {"engines":1,
                        "fuel_amount_tons":3.38,
                        "burn_time_sec":378}
     
     */
    
    let name: String
    let flickrImages: [String]
    let id: String

    let height: Length
    let diameter: Length
    let mass: Mass
    let payloadWeights: [PayloadWeight]

    let firstFlight: String
    let country: String
    let costPerLaunch: Int
    let firstStage: Stage
    let secondStage: Stage
}

struct PayloadWeight: Decodable {
    let id: String
    let kg: Int
    let lb: Int
}

struct Length: Decodable {
    let meters: Double
    let feet: Double
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
