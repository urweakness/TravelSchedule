import SwiftUI

final class StoriesViewModel: ObservableObject {
    
    @inline(__always)
    @Published private(set) var verticalDragValue: CGFloat = 0
    
    @Published private(set) var stories: [StoryModel] = stubStories
    @Published private(set) var currentStory: StoryModel?
    @Published private(set) var currentProgressValue: CGFloat = 0.0
    
    @Published var screenSize: CGSize = .zero
    @Published var currentStoryIndex: Int = 0
    
    private let storyTimeout = TimeInterval(GlobalConstants.storyPreviewTimeout)
    private let storyAnimationTimoutTimer = StoryAnimationTimer()
    private let velocityThreshold: CGFloat = 1300
    
    var dismiss: DismissAction?
    
    @inline(__always)
    var approximatedVerticalDragValue: CGFloat {
        verticalDragValue / screenSize.height
    }
    
    func switchPreviousStories() {
//        for index in stride(from: currentStoryIndex - 1, through: 0, by: -1) {
//            guard let story = stories[safe: index] else { return }
//            
//            let newStory = story.switchedCheckModel(to: true)
//            withAnimation {
//                stories[currentStoryIndex] = newStory
//            }
//        }
    }
    
    func progressValue(storyIndex: Int) -> CGFloat {
        if
            let story = stories[safe: storyIndex],
            story.isCheckedOut
        {
            return 1.0
        }
        
        return currentStoryIndex == storyIndex ? currentProgressValue : 0.0
    }
    
    func makeStoryGesture() -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { [weak self] value in
                self?.verticalDragValue = abs(value.translation.height)
            }
            .onEnded { [weak self] value in
                guard let self else { return }
                
                let isSwipeDown = value.velocity.height > velocityThreshold
                if approximatedVerticalDragValue >= 0.3 || isSwipeDown {
                    invalidateTimer()
                    dismissView()
                    return
                }
                
                guard verticalDragValue == 0 else {
                    withAnimation {
                        self.verticalDragValue = 0
                    }
                    return
                }
                
                guard value.translation.width.isZero else {
                    if value.translation.width > 0 {
                        trySetPreviousStory()
                    } else {
                        trySetNextStory()
                    }
                    return
                }
                
                if value.location.x < screenSize.width / 2 {
                    trySetPreviousStory()
                } else {
                    trySetNextStory()
                }
            }
    }
    
    private func dismissView() {
        dismiss?()
        invalidateTimer()
        updateCurrentStoryCheckedOutStatus(false)
        updateCurrentProgressValueAnimated(0, instantly: true)
        dismiss = nil
        currentStory = nil
        verticalDragValue = 0
        currentStoryIndex = 0
    }
    
    func invalidateTimer() {
        storyAnimationTimoutTimer.invalidateTimer()
    }
    
    func trySetNewStory() {
        guard let story = stories[safe: currentStoryIndex] else {
            invalidateTimer()
            dismissView()
            return
        }
        
        withAnimation {
            currentStory = story
        }

        updateCurrentProgressValueAnimated(1.0)
        updateTimer()
    }
    
    func trySetPreviousStory() {
        storyAnimationTimoutTimer.invalidateTimer()
        
        updateCurrentProgressValueAnimated(0.0, instantly: true)
        updateCurrentStoryCheckedOutStatus(false)
        currentStoryIndex = max(0, currentStoryIndex - 1)
        updateCurrentStoryCheckedOutStatus(false)
        
        trySetNewStory()
    }
    
    func trySetNextStory() {
        storyAnimationTimoutTimer.invalidateTimer()
        
        updateCurrentProgressValueAnimated(0.0, instantly: true)
        updateCurrentStoryCheckedOutStatus(true)
        currentStoryIndex += 1
        
        trySetNewStory()
    }
    
    private func updateTimer() {
        storyAnimationTimoutTimer.updateTimer(interval: storyTimeout) { [weak self] in
            self?.trySetNextStory()
        }
    }
    
    private func updateCurrentStoryCheckedOutStatus(_ isCheckedOut: Bool) {
        guard let newStory = currentStory?.switchedCheckModel(to: isCheckedOut) else { return }
        
        withAnimation(.linear(duration: 0)) {
            stories[currentStoryIndex] = newStory
            self.currentStory = newStory
        }
    }
    
    private func updateCurrentProgressValueAnimated(_ value: CGFloat, instantly: Bool = false) {
        withAnimation(instantly ? nil : .linear(duration: storyTimeout)) {
            currentProgressValue = value
        }
    }
}
