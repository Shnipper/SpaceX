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

}
