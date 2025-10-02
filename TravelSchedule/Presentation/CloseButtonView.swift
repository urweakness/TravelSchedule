struct CloseButtonView: View {
	
	@Environment(\.dismiss) private var dismiss
	
	var body: some View {
		Button(action: { dismiss() }) {
			Circle()
				.fill(.travelWhite)
				.overlay {
					Image(systemName: "xmark")
						.resizable()
						.font(.bold34)
						.foregroundStyle(.white)
						.frame(width: 10, height: 10)
				}
				.frame(width: 30, height: 30)
				.shadow(color: .white.opacity(0.2), radius: 5)
		}
		.frame(width: 24, height: 24)
		.padding(.trailing, 16)
	}
}