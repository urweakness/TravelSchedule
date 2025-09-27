import WebKit
import SwiftUI

struct WebViewRepresentable: UIViewRepresentable {
	let url: URL
	@Binding var isLoading: Bool
	
	func makeUIView(context: Context) -> some UIView {
		let webView = WKWebView()
		
		context.coordinator.observeProgress(webView)
		
		webView.load(
			URLRequest(url: url)
		)
		
		return webView
	}
	
	func updateUIView(_ uiView: UIViewType, context: Context) {}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(isLoading: $isLoading)
	}
	
	class Coordinator: NSObject {
		@Binding var isLoading: Bool
		
		weak var webView: WKWebView?
		
		private var progressObservation: NSKeyValueObservation?
		
		init(isLoading: Binding<Bool>) {
			self._isLoading = isLoading
		}
		
		func observeProgress(_ webView: WKWebView) {
			self.webView = webView
			
			progressObservation = webView
				.observe(\.estimatedProgress, options: .new) { obsWebView, _ in
					
					let progress = obsWebView.estimatedProgress
					
					DispatchQueue.main.async { [weak self] in
						if progress >= 0.99 {
							self?.isLoading = false
						} else {
							self?.isLoading = true
						}
					}
			}
		}
		
		private func deinitObserver() {
			progressObservation?.invalidate()
			progressObservation = nil
		}
		
		deinit {
			deinitObserver()
		}
	}
}
