import Foundation

struct Rocket: Decodable {
    
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
    
    var firstFlightToPresent: String {
        reformat(inputDate: firstFlight)
    }
    
    var leoPayloadWeight: PayloadWeight? {
        var value: PayloadWeight? = nil
        for payloadWeight in payloadWeights {
            if payloadWeight.id == "leo" {
                value = payloadWeight
            }
        }
        return value
    }

    private func reformat(inputDate: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: inputDate) {
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: "ru_RU")
            outputFormatter.setLocalizedDateFormatFromTemplate("MMMMddYYYY")
            let outputDate = outputFormatter.string(from: date)
            return outputDate
        } else {
            return inputDate
        }
    }
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
