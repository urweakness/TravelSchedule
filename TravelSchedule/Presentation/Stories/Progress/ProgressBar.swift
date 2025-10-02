struct ProgressBar: View {
	
	// MARK: - Private(set) Properties
	let storyPartsCount: Int
	let progress: CGFloat
	
	// MARK: - Body
	var body: some View {
		GeometryReader {
			let size = $0.size
			
			ZStack(alignment: .leading) {
				RoundedRectangle(cornerRadius: .progressBarCornerRadius)
					.frame(width: size.width, height: .progressBarHeight)
					.foregroundStyle(.white)
				
				RoundedRectangle(cornerRadius: .progressBarCornerRadius)
					.frame(
						width:
							min(
								progress * size.width,
								size.width
							)
						,
						height: .progressBarHeight
					)
					.foregroundStyle(.travelBlue)
			}
			.mask {
				MaskView(numOfSections: storyPartsCount)
			}
		}
	}
}

private struct MaskView: View {
	
	let numOfSections: Int
	
	var body: some View {
		HStack {
			ForEach(0..<numOfSections, id: \.self) { id in
				MaskFragmentView()
			}
		}
	}
}

private struct MaskFragmentView: View {
	var body: some View {
		RoundedRectangle(cornerRadius: .progressBarCornerRadius)
			.fixedSize(horizontal: false, vertical: true)
			.frame(height: .progressBarHeight)
			.foregroundStyle(.white)
	}
}