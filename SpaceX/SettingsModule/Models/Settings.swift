import Foundation

struct Settings: Codable {
    let height: UnitOfLength
    let diameter: UnitOfLength
    let mass: UnitOfWeight
    let payloadWeight: UnitOfWeight
}

enum UnitOfWeight: String, Codable {
    case kg = ", kg"
    case lb = ", lb"
}

enum UnitOfLength: String, Codable {
    case meters = ", m"
    case feet = ", ft"
}

enum RocketParameters: String, CaseIterable  {
    case height = "Высота"
    case diameter = "Диаметр"
    case mass = "Масса"
    case payloadWeight = "Нагрузка"
}
