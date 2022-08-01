import Foundation

enum Link {
    static let rocketDetails = "https://api.spacexdata.com/v4/rockets"
    static let launches = "https://api.spacexdata.com/v4/launches"
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

protocol NetworkManagerProtocol {
    
    static var shared: NetworkManager { get }
    
    func fetchRocketData(with completion: @escaping(
        Result<[Rocket], NetworkError>) -> Void)
    
    func fetchImage(from url: String?, with completion: @escaping(
        Result<Data, NetworkError>) -> Void)
    
    func fetchLaunchesData(with completion: @escaping(
        Result<[Launch], NetworkError>) -> Void)
    
//    func fetchData<T:Decodable>(by link: String,
//                                with completion: @escaping(Result<T, NetworkError>) -> Void)
}


final class NetworkManager: NetworkManagerProtocol {
    
    static let shared = NetworkManager()
    
    func fetchRocketData(with completion: @escaping(Result<[Rocket],
                                                    NetworkError>) -> Void) {
        guard let url = URL(string: Link.rocketDetails) else {
            completion(.failure(.invalidURL))
            return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let rockets = try decoder.decode([Rocket].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(rockets))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func fetchImage(from url: String?,
                           with completion: @escaping(Result<Data,
                                                      NetworkError>) -> Void) {
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
    
    func fetchLaunchesData(with completion: @escaping(Result<[Launch],
                                                      NetworkError>) -> Void) {
        guard let url = URL(string: Link.launches) else {
            completion(.failure(.invalidURL))
            return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let launches = try decoder.decode([Launch].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(launches))
                }
            }   catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
//    func fetchData<T:Decodable>(by link: String,
//                                with completion: @escaping(Result<T, NetworkError>) -> Void) {
//
//        guard let url = URL(string: link) else {
//            completion(.failure(.invalidURL))
//            return
//        }
//
//        URLSession.shared.dataTask(with: url) { data, _, error in
//            guard let data = data else {
//                completion(.failure(.noData))
//                return
//            }
//
//            do {
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                let value = try decoder.decode(T.self, from: data)
//                DispatchQueue.main.async {
//                    completion(.success(value))
//                }
//            } catch {
//                completion(.failure(.decodingError))
//            }
//        }.resume()
//    }
}

