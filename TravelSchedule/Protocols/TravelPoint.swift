protocol TravelPoint: Hashable, Identifiable {
    var id: Self { get }
    var name: String { get }
    static var noContentTitleText: String { get }
}
