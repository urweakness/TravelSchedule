enum GlobalConstants {
    static let apiKey = "b5389546-05d0-460f-834e-5530e6a3fda6"
	static let userAgreementURLString = "https://yandex.ru/legal/practicum_offer"
	static let storyPreviewTimeout: Double = 10
}

let mockStories: [StoryModel] = [
	.init(
		previewImageResource: ._1PreviewIllustration,
		storyParts: [
			.init(
				fullImageResource: ._11BigIllustration,
				title: "Хорошо - это когда хорошо",
				description: "Как же было бы хорошо, если бы документация API не расходилась с реальностью",
				isCheckedOut: false
			)
		]
	),
	.init(
		previewImageResource: ._2PreviewIllustration,
		storyParts: [
			.init(
				fullImageResource: ._21BigIllustration,
				title: "Ночь, улица, фонарь, аптека",
				description: "Хорошо - это когда, как минимум, неплохо",
				isCheckedOut: false
			),
			.init(
				fullImageResource: ._22BigIllustration,
				title: "Бессмысленный и тусклый свет",
				description: "Хорошо - это когда сторисы имеют применение",
				isCheckedOut: false
			),
			.init(
				fullImageResource: ._81BigIllustration,
				title: "Продам гараж",
				description: "Хорошо - это когда ТЗ неизменно на протяжении всего проекта",
				isCheckedOut: false
			)
		]
	),

	.init(
		previewImageResource: ._3PreviewIllustration,
		storyParts: [
			.init(
				fullImageResource: ._31BigIllustration,
				title: "А что тут еще сказать?",
				description: "Покупайте биткоины!",
				isCheckedOut: false
			),
			.init(
				fullImageResource: ._32BigIllustration,
				title: "Выйду ночью в поле с конем",
				description: "Ночкой темной тихо пойдем",
				isCheckedOut: false
			)
		]
	),

	.init(
		previewImageResource: ._4PreviewIllustration,
		storyParts: [
			.init(
				fullImageResource: ._41BigIllustration,
				title: "Погода",
				description: "Сегодня слегка ветренно",
				isCheckedOut: false
			),
			.init(
				fullImageResource: ._42BigIllustration,
				title: "🤔",
				description: "Завтра - дождь",
				isCheckedOut: false
			)
		]
	),

	.init(
		previewImageResource: ._5PreviewIllustration,
		storyParts: [
			.init(
				fullImageResource: ._51BigIllustration,
				title: "Может",
				description: "Может дифференциальное уравнение?",
				isCheckedOut: false
			),
			.init(
				fullImageResource: ._52BigIllustration,
				title: "А может не может?",
				description: "Может и не может",
				isCheckedOut: false
			)
		]
	),

	.init(
		previewImageResource: ._6PreviewIllustration,
		storyParts: [
			.init(
				fullImageResource: ._61BigIllustration,
				title: "Слишком много текста",
				description: "Еще больше",
				isCheckedOut: false
			),
			.init(
				fullImageResource: ._62BigIllustration,
				title: "Текст",
				description: "Sample text",
				isCheckedOut: false
			)
		]
	)
]
