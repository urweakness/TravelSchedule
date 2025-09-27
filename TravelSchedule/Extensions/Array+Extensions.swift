// MARK: - Array Extensions

// safe index subscript
extension Array {
    subscript (safe index: Int) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
