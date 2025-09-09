import DeveloperToolsSupport
import Foundation

struct StoryModel: Identifiable {
    let id = UUID()
    let previewImageResource: ImageResource
    let fullImageResource: ImageResource
    let title: String
    let description: String
    let isCheckedOut: Bool
    
    func switchedCheckModel(to isCheckedOut: Bool) -> Self {
        .init(
            previewImageResource: previewImageResource,
            fullImageResource: fullImageResource,
            title: title,
            description: description,
            isCheckedOut: isCheckedOut
        )
    }
}
