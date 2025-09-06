// MARK: - Extensions
// MARK: Array
// safe index subscript

extension Array {
    subscript (safe index: Int) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
