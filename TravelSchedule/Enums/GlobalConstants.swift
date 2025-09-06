enum GlobalConstants {
    static let apiKey = "b5389546-05d0-460f-834e-5530e6a3fda6"
    static let storyPreviewTimeout: UInt8 = 10
}


let templateText = "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text"
let stubStories: [StoryModel] = [
    .init(previewImageResource: ._1PreviewIllustration, fullImageResource: ._11BigIllustration, title: .init(templateText), description: templateText, isCheckedOut: false),
    
    .init(previewImageResource: ._2PreviewIllustration, fullImageResource: ._21BigIllustration, title: .init(templateText), description: templateText, isCheckedOut: false),
    
    .init(previewImageResource: ._3PreviewIllustration, fullImageResource: ._31BigIllustration, title: .init(templateText), description: templateText, isCheckedOut: false),
    
    .init(previewImageResource: ._4PreviewIllustration, fullImageResource: ._41BigIllustration, title: .init(templateText), description: templateText, isCheckedOut: false),
    
    .init(previewImageResource: ._5PreviewIllustration, fullImageResource: ._51BigIllustration, title: .init(templateText), description: templateText, isCheckedOut: false),
    
    .init(previewImageResource: ._6PreviewIllustration, fullImageResource: ._61BigIllustration, title: .init(templateText), description: templateText, isCheckedOut: false)
]
