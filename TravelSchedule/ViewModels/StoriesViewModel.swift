import SwiftUI
import Combine

final class StoriesViewModel: ObservableObject {
    
    @Published var screenSize: CGSize = .zero
    @Published private(set) var currentStoryIndex: Int = -1
    @Published private(set) var currentProgressValue: CGFloat = 0.0
    @Published private(set) var stories: [StoryModel]?
    @Published private(set) var currentStory: StoryModel?
    
    private let storyTimeout = TimeInterval(GlobalConstants.storyPreviewTimeout)
    private let storyAnimationTimoutTimer = StoryAnimationTimer()
    
    private var cancellables = Set<AnyCancellable>()
    
    let dragGestureModel = DragGestureObject()
    var dismiss: DismissAction?
    
    init() {
        setupDragGestureModel()
        setupBindings()
    }
    
    func viewDidAppear(
        screenSize: CGSize,
        storyIndex: Int,
        stories: [StoryModel]
    ) {
        updateCurrentProgressValueAnimated(0, instantly: true)
        
        self.stories = stories
        self.currentStoryIndex = storyIndex
        self.screenSize = screenSize

        updateTimer()
    }
    
    func dismissView() {
        invalidateTimer()
        dismiss?()
    }
    
    private func setupDragGestureModel() {
        dragGestureModel.screenSize = { [weak self] in
            self?.screenSize ?? .zero
        }
        dragGestureModel.dismiss = { [weak self] in
            self?.dismissView()
        }
        dragGestureModel.invalidateTimer = { [weak self] in
            self?.invalidateTimer()
        }
        dragGestureModel.performPage = { [weak self] pageSpec in
            guard let self else { return }
            
            switch pageSpec {
            case .none:
                break
            case .next:
                updateCurrentStoryCheckedOutStatus(true)
                currentStoryIndex += 1
            case .prev:
                updateCurrentStoryCheckedOutStatus(false)
                currentStoryIndex = max(currentStoryIndex - 1, 0)
            }
        }
    }
    
    private func setupBindings() {
        $currentStoryIndex
            .removeDuplicates()
            .map { [weak self] index -> StoryModel? in
                
                guard
                    let self,
                    let story = stories?[safe: index]
                else { return nil }
                
                return story
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.currentStory, on: self)
            .store(in: &cancellables)
        
        $currentStory
            .removeDuplicates()
            .sink { [weak self] story in
                guard
                    let self,
                    let story,
                    let storyIndex = self.stories?.firstIndex(of: story)
                else {
                    self?.invalidateTimer()
                    self?.dismissView()
                    return
                }
                
                stories?[storyIndex] = story
            }
            .store(in: &cancellables)
        
        $currentStoryIndex
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.invalidateTimer()
                self?.updateTimer()
                self?.updateCurrentProgressValueAnimated(0, instantly: true)
                self?.updateCurrentProgressValueAnimated(1)
            }
            .store(in: &cancellables)
    }
    
    private func invalidateTimer() {
        storyAnimationTimoutTimer.invalidateTimer()
    }
    
    func progressValue(storyIndex: Int) -> CGFloat {
        guard let story = stories?[safe: storyIndex] else {
            return 0.0
        }
        
        if currentStoryIndex == storyIndex {
            return currentProgressValue
        } else {
            return story.isCheckedOut ? 1.0 : 0.0
        }
    }
    
    private func updateTimer() {
        storyAnimationTimoutTimer.updateTimer(interval: storyTimeout) { [weak self] in
            self?.updateCurrentStoryCheckedOutStatus(true)
            self?.currentStoryIndex += 1
        }
    }
    
    private func updateCurrentStoryCheckedOutStatus(_ isCheckedOut: Bool) {
        guard let newStory = currentStory?.switchedCheckModel(to: isCheckedOut) else { return }
        
        withAnimation(.linear(duration: 0)) {
            stories?[currentStoryIndex] = newStory
        }
    }
    
    private func updateCurrentProgressValueAnimated(_ value: CGFloat, instantly: Bool = false) {
        withAnimation(instantly ? nil : .linear(duration: storyTimeout)) {
            currentProgressValue = value
        }
    }
}
