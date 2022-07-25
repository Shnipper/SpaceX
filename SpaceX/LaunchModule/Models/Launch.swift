import Foundation

struct Launch: Decodable {
    
    /*
    "rocket":    "5e9d0d95eda69955f709d1eb"
    "success":   false
    "name":      "FalconSat"
    "date_utc":  "2006-03-24T22:30:00.000Z"
     */

    let rocket: String
    let success: Bool?
    let name: String
    let dateUtc: String

    var dateToPresent: String {
        format(inputedDate: dateUtc)
    }
    
    private func format(inputedDate: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
        
        if let date = inputFormatter.date(from: inputedDate) {
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: "ru_RU")
            outputFormatter.setLocalizedDateFormatFromTemplate("MMMMddYYYY")
            let outputDate = outputFormatter.string(from: date)
            return outputDate
        } else {
            return inputedDate
        }
    }
}
