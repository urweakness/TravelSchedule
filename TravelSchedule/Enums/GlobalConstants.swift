enum GlobalConstants {
    static let apiKey = "b5389546-05d0-460f-834e-5530e6a3fda6"
    static let storyPreviewTimeout: UInt8 = 10
}


let templateText = "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text"
let mockStories: [StoryModel] = [
	.init(
		previewImageResource: ._1PreviewIllustration,
		storyParts: [
			.init(
				fullImageResource: ._11BigIllustration,
				title: templateText,
				description: templateText,
				isCheckedOut: false
			),
			.init(
				fullImageResource: ._12BigIllustration,
				title: templateText,
				description: templateText,
				isCheckedOut: false
			)
		]
	),
	.init(
		previewImageResource: ._2PreviewIllustration,
		storyParts: [
			.init(
				fullImageResource: ._21BigIllustration,
				title: templateText,
				description: templateText,
				isCheckedOut: false
			),
			.init(
				fullImageResource: ._22BigIllustration,
				title: templateText,
				description: templateText,
				isCheckedOut: false
			)
		]
	),

	.init(
		previewImageResource: ._3PreviewIllustration,
		storyParts: [
			.init(
				fullImageResource: ._31BigIllustration,
				title: templateText,
				description: templateText,
				isCheckedOut: false
			),
			.init(
				fullImageResource: ._32BigIllustration,
				title: templateText,
				description: templateText,
				isCheckedOut: false
			)
		]
	),

	.init(
		previewImageResource: ._4PreviewIllustration,
		storyParts: [
			.init(
				fullImageResource: ._41BigIllustration,
				title: templateText,
				description: templateText,
				isCheckedOut: false
			),
			.init(
				fullImageResource: ._42BigIllustration,
				title: templateText,
				description: templateText,
				isCheckedOut: false
			)
		]
	),

	.init(
		previewImageResource: ._5PreviewIllustration,
		storyParts: [
			.init(
				fullImageResource: ._51BigIllustration,
				title: templateText,
				description: templateText,
				isCheckedOut: false
			),
			.init(
				fullImageResource: ._52BigIllustration,
				title: templateText,
				description: templateText,
				isCheckedOut: false
			)
		]
	),

	.init(
		previewImageResource: ._6PreviewIllustration,
		storyParts: [
			.init(
				fullImageResource: ._61BigIllustration,
				title: templateText,
				description: templateText,
				isCheckedOut: false
			),
			.init(
				fullImageResource: ._62BigIllustration,
				title: templateText,
				description: templateText,
				isCheckedOut: false
			)
		]
	)
]
