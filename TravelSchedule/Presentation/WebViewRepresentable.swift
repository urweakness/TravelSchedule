import WebKit
import SwiftUI

struct WebViewRepresentable: UIViewRepresentable {
	let url: URL
	@Binding var isLoading: Bool
	var colorScheme: ColorScheme
	
	func makeUIView(context: Context) -> some UIView {
		let config = WKWebViewConfiguration()

		let userScript = WKUserScript(source: helperJS, injectionTime: .atDocumentStart, forMainFrameOnly: true)
		config.userContentController.addUserScript(userScript)
		
		let webView = WKWebView(frame: .zero, configuration: config)
		
		context.coordinator.observeProgress(webView)
		webView.load(URLRequest(url: url))
		return webView
	}
	
	func updateUIView(_ uiView: UIViewType, context: Context) {
		if let webView = uiView as? WKWebView {
			webView.overrideUserInterfaceStyle = (colorScheme == .dark) ? .dark : .light
			let themeString = (colorScheme == .dark) ? "dark" : "light"
			let js = "window.__applyNativeTheme && window.__applyNativeTheme('\(themeString)');"
			webView.evaluateJavaScript(js, completionHandler: nil)
		}
	}
	
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
	
	// window.__applyNativeTheme(theme)
	private let helperJS = """
		(function() {
			window.__applyNativeTheme = function(theme) {
				try {
					// remove previous style if exists
					var prev = document.getElementById('native-theme-style');
					if (prev) prev.parentNode.removeChild(prev);
		
					var style = document.createElement('style');
					style.id = 'native-theme-style';
		
					// базовые правила — можно расширить
					var darkCSS = `
						html, body, * {
							background-color: #1B1C22 !important;
							color: #E6E6E6 !important;
							border-color: rgba(255,255,255,0.12) !important;
							box-shadow: none !important;
							background-image: none !important;
						}
						a { color: #0A84FF !important; }
						img, svg, video { opacity: 0.98 !important; filter: none !important; }
					`;
					var lightCSS = `
						html, body, * {
							background-color: #FFFFFF !important;
							color: #111111 !important;
							border-color: rgba(0,0,0,0.12) !important;
							box-shadow: none !important;
						}
						a { color: #007AFF !important; }
					`;
		
					style.innerHTML = (theme === 'dark') ? darkCSS : lightCSS;
					if (document.head) document.head.appendChild(style);
		
					// метка для проверки из native
					document.documentElement.setAttribute('data-native-theme', theme);
		
					// Подмена matchMedia чтобы сайт, проверяющий prefers-color-scheme, получил корректный ответ
					(function(origMatchMedia, currentTheme) {
						window.matchMedia = function(query) {
							if (query === '(prefers-color-scheme: dark)') {
								var mql = {
									matches: (currentTheme === 'dark'),
									media: query,
									onchange: null,
									addListener: function(){},    // deprecated but sometimes used
									removeListener: function(){},
									addEventListener: function(){},
									removeEventListener: function(){},
									dispatchEvent: function(){ return false; }
								};
								return mql;
							}
							return origMatchMedia(query);
						};
					})(window.matchMedia.bind(window), theme);
		
				} catch(e) {
					// swallow so it won't break site
					console && console.error && console.error('applyNativeTheme error', e);
				}
			};
		})();
		"""
}
