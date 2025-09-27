import DeveloperToolsSupport

enum ErrorKind {
    
    case noInternet
    case serverError
    case unknown(Error)
    
    var description: String {
        switch self {
        case .noInternet:
            return "Нет интернета"
        case .serverError:
            return "Ошибка сервера"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
    
    var imageResource: ImageResource {
        switch self {
        case .noInternet:
            return .noInternet
        case .serverError, .unknown:
            return .serverError
        }
    }
}

// MARK: - ErrorKind Extensions

// MARK: Internal Hashable Conformance
extension ErrorKind: Hashable {
    static func == (lhs: ErrorKind, rhs: ErrorKind) -> Bool {
        lhs.description == rhs.description
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(description)
    }
}
