import Foundation

struct Settings {
    var height: UnitOfLength
    var diameter: UnitOfLength
    var mass: UnitOfWeight
    var payloadWeights: UnitOfWeight
}

enum UnitOfWeight: String {
    case kg = ", kg"
    case lb = ", lb"
}

enum UnitOfLength: String {
    case meters = ", m"
    case feet = ", ft"
}

enum RocketParameters: String, CaseIterable  {
    case height = "Высота"
    case diameter = "Диаметр"
    case mass = "Масса"
    case payloadWeights = "Нагрузка"
}

 
