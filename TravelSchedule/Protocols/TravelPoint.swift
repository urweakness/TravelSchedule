protocol TravelPoint: Hashable, Identifiable, CaseIterable {
    var id: Self { get }
    var name: String { get }
    static var noContentTitleText: String { get }
}
