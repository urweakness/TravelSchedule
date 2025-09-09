import UIKit

final class StoriesUIKitViewModel: ObservableObject {
    @Published var stories: [StoryModel] = stubStories
    @Published var currentStory: StoryModel?
    @Published var currentStoryIndex: Int = 0
    
    private let duration = TimeInterval(GlobalConstants.storyPreviewTimeout)
    
    var progressView: ((UUID?) -> UIProgressView?)?
    var storyDidSet: (() -> Void)?
    var dismiss: (() -> Void)?
    
//    private let progressAnimator = ProgressAnimator()
    
    func viewDidLoad() {
        trySetNewStory()
    }
    
    func trySetNewStory() {
        guard let story = stories[safe: currentStoryIndex] else {
            stopAnimations()
            dismiss?()
            return
        }
        
        currentStory = story
        updateTimer()
        storyDidSet?()
    }
    
    func trySetPreviousStory() {
        stopAnimations()
        
        updateProgressValue(value: 0, flag: false)
        updateCurrentStoryCheckedOutStatus(false)
        currentStoryIndex = max(0, currentStoryIndex - 1)
        updateCurrentStoryCheckedOutStatus(false)
        
        trySetNewStory()
    }
    
    func trySetNextStory() {
        stopAnimations()
        
        updateProgressValue(value: 0, flag: false)
        updateCurrentStoryCheckedOutStatus(true)
        currentStoryIndex += 1
        
        trySetNewStory()
    }
    
    private func updateTimer() {
        updateProgressValue(value: 1)
        Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { [weak self] _ in
            self?.trySetNextStory()
        }
    }
    
    private func updateProgressValue(value: Float, flag animated: Bool = true) {
        let currentStoryUUID = currentStory?.id
        let progressView = progressView?(currentStoryUUID)
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: [.curveLinear]
        ) {
            progressView?.setProgress(value, animated: animated)
        }
    }
    
    private func stopAnimations() {
        let currentStoryUUID = currentStory?.id
        let progressView = progressView?(currentStoryUUID)
        progressView?.layer.removeAllAnimations()
    }
    
    private func updateCurrentStoryCheckedOutStatus(_ status: Bool) {
        guard
            let _ = stories[safe: currentStoryIndex],
            let newStory = currentStory?.switchedCheckModel(to: status)
        else { return }
        
        stories[currentStoryIndex] = newStory
        currentStory = newStory
    }
}
