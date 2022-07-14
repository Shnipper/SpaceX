import Foundation

enum Link: String {
    case rocketDetails = "https://api.spacexdata.com/v4/rockets"
    case launches = "https://api.spacexdata.com/v4/launches"
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

final class NetworkManager {
    
    static func fetchRocketData(with completion: @escaping([Rocket]) -> Void) {
        guard let url = URL(string: Link.rocketDetails.rawValue) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let rockets = try decoder.decode([Rocket].self, from: data)
                DispatchQueue.main.async {
                    completion(rockets)
                }
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
    static func fetchImage(from url: String?,
                           with completion: @escaping(Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: url ?? "") else {
            completion(.failure(.invalidURL))
            return
        }
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                completion(.failure(.noData))
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(imageData))
            }
        }
    }
    
    static func fetchLaunchesData(with completion: @escaping([Launch]) -> Void) {
        guard let url = URL(string: Link.launches.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let launches = try decoder.decode([Launch].self, from: data)
                DispatchQueue.main.async {
                    completion(launches)
                }
            }   catch let error {
                print(error)
            }
        }.resume()
    }
}

