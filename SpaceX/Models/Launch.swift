import Foundation

struct Launch: Decodable {

    let rocket: String
    let success: Bool?
    let name: String
    let dateUtc: String
    let id: String
}
