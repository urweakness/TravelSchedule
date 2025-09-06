enum LoadingState: Equatable {
    case idle
    case fetching
    case error(ErrorKind)
}
