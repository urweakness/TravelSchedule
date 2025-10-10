import SwiftUI

struct TravelScheduleStoryProgressViewStyle: ProgressViewStyle {
	// --- body ---
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(.white)
                Capsule()
                    .fill(.blue)
                    .frame(width: CGFloat(configuration.fractionCompleted ?? 0) * proxy.size.width)
            }
        }
        .frame(height: 6)
    }
}
