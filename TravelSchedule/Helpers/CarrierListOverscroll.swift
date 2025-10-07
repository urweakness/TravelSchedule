import CoreGraphics

struct CarrierListOverscroll {
    var bottomPadding: CGFloat {
        bottomButtonPadding + safeAreaInset + verticalStackSpacing + buttonTextFont
    }
    
    private let bottomButtonPadding: CGFloat = 20
    private let safeAreaInset: CGFloat = 32
    private let verticalStackSpacing: CGFloat = 8
    private let buttonTextFont: CGFloat = 17
}
