import SwiftUI

struct StoriesView: View {
    @State private(set) var stories: [StoryModel]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(alignment: .center, spacing: 16) {
                ForEach(stories) { story in
                    StoryView(
                        attributedTitle: story.attributedTitle,
                        imageResource: story.imageResource,
                        checked: story.isChecked
                    )
                }
            }
            .padding(.leading, 16)
        }
        .frame(height: 140)
        .padding(.vertical, 24)
    }
}


struct StoryModel: Identifiable {
    let id: UUID = UUID()
    let imageResource: ImageResource
    let attributedTitle: AttributedString
    let isChecked: Bool
}


let templateText = "Text Text Text Text Text Text Text Text Text Text"
let stories: [StoryModel] = [
    .init(imageResource: ._1PreviewIllustration, attributedTitle: .init(templateText), isChecked: false),
    .init(imageResource: ._2PreviewIllustration, attributedTitle: .init(templateText), isChecked: false),
    .init(imageResource: ._3PreviewIllustration, attributedTitle: .init(templateText), isChecked: true),
    .init(imageResource: ._4PreviewIllustration, attributedTitle: .init(templateText), isChecked: true),
    .init(imageResource: ._5PreviewIllustration, attributedTitle: .init(templateText), isChecked: true)
]


#Preview {
    StoriesView(stories: stories)
}
