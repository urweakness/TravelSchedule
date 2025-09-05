enum FullScreenCover: Identifiable, Hashable {
    case none
    case story
    case error(ErrorKind)
    
    var id: Self { self }
}
