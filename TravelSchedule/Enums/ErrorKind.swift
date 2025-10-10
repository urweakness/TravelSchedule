import DeveloperToolsSupport

enum ErrorKind: Error {
    
    case noInternet
    case serverError
    case unknown(Error)
    
    var description: String {
        switch self {
        case .noInternet:
			.init(localized: .noInternet)
        case .serverError:
			.init(localized: .serverError)
        case .unknown(let error):
            error.localizedDescription
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
