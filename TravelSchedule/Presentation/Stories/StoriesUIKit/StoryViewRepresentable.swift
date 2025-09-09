import SwiftUI

struct StoryViewRepresentable: UIViewRepresentable {
    @State var viewModel: StoriesUIKitViewModel
    var gesture: StoriesGesture
    let screenSize: CGSize
    
    func makeUIView(context: Context) -> UIView {
        let uiView = StoryUIKitView(
            frame: .init(origin: .zero, size: screenSize),
            gesture: gesture,
            viewModel: viewModel
        )
        return uiView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
//        uiView.
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: StoryViewRepresentable
        
        init(_ parent: StoryViewRepresentable) {
            self.parent = parent
        }
    }
}

final class StoryUIKitView: UIView {
    var gesture: StoriesGesture
    var viewModel: StoriesUIKitViewModel
    
    init(
        frame: CGRect,
        gesture: StoriesGesture,
        viewModel: StoriesUIKitViewModel
    ) {
        self.gesture = gesture
        self.viewModel = viewModel
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var timelineView: UIStackView = {
       let view = UIStackView(arrangedSubviews: [])
        view.axis = .horizontal
        view.spacing = 6
        view.distribution = .fillEqually
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var closeButtonView: UIButton = {
        let view = UIButton(type: .custom)
        view.setImage(UIImage(systemName: "xmark"), for: .normal)
        view.tintColor = .white
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 60
        return view
    }()
    
    private lazy var titleView: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.textColor = .white
        view.numberOfLines = 3
        return view
    }()
    
    private lazy var subtitleView: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 17, weight: .regular)
        view.textColor = .white
        view.numberOfLines = 3
        return view
    }()
    
    override func didMoveToWindow() {
        backgroundColor = .travelWhite
        
        setUpTimeline()
        activateTimelineConstraints()
        activateConstriants()
        
        setUpGesture()
        setUpViewModel()
        
        viewModel.viewDidLoad()
    }
    
    func setUpGesture() {
        
        gesture.screenSize = bounds.size
        gesture.location = { gesture in
            gesture.location(in: self)
        }
        gesture.translation = { gesture in
            gesture.translation(in: self)
        }
        gesture.velocity = { gesture in
            gesture.velocity(in: self)
        }
        
        gesture.trySetNextStory = viewModel.trySetNextStory
        gesture.trySetPreviousStory = viewModel.trySetPreviousStory
        gesture.restoreViewNormalState = { [weak self] in
            guard let self else { return }
            layoutSubviews()
        }
        gesture.dismiss = { [weak self] in
            self?.inputViewController?.dismiss(animated: true)
        }
        
        addGestureRecognizer(gesture.panGesture)
        addGestureRecognizer(gesture.tapGesture)
    }
    
    func setUpViewModel() {
        viewModel.progressView = { [weak self] uuid in
            guard let uuid else { return nil }
            return self?.timelineView.arrangedSubviews.first(where: { $0.accessibilityIdentifier == "\(uuid)" }) as? UIProgressView
        }
        viewModel.storyDidSet = { [weak self] in
            self?.updateContent()
        }
        viewModel.dismiss = { [weak self] in
            self?.inputViewController?.dismiss(animated: true)
        }
    }

    func updateContent() {
        guard let story = viewModel.currentStory else { return }
        
        imageView.image = UIImage(resource: story.fullImageResource)
        titleView.text = story.title
        subtitleView.text = story.description
    }
    
    func setUpTimeline() {
        timelineView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        viewModel.stories.forEach {
            let progressView = UIProgressView(progressViewStyle: .default)
            progressView.progressTintColor = .travelBlue
            progressView.trackTintColor = .white
            progressView.accessibilityIdentifier = "\($0.id)"
            
            progressView.layer.cornerRadius = 3
            progressView.clipsToBounds = true
            progressView.layer.masksToBounds = true
            
            timelineView.addArrangedSubview(progressView)
        }
    }
    
    func activateTimelineConstraints() {
        timelineView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageView)
        imageView.addSubview(timelineView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            imageView.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            imageView.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor
            ),
            imageView.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor
            ),
            
            timelineView.topAnchor.constraint(
                equalTo: imageView.topAnchor,
                constant: 24
            ),
            timelineView.leadingAnchor.constraint(
                equalTo: imageView.leadingAnchor,
                constant: 16
            ),
            timelineView.trailingAnchor.constraint(
                equalTo: imageView.trailingAnchor,
                constant: -16
            ),
            timelineView.heightAnchor.constraint(
                equalToConstant: 6
            )
        ])
    }
    
    func activateConstriants() {
        closeButtonView.translatesAutoresizingMaskIntoConstraints = false
        titleView.translatesAutoresizingMaskIntoConstraints = false
        subtitleView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(closeButtonView)
        addSubview(titleView)
        addSubview(subtitleView)
        
        NSLayoutConstraint.activate([
            closeButtonView.topAnchor.constraint(
                equalTo: timelineView.bottomAnchor,
                constant: 16
            ),
            closeButtonView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            ),
            closeButtonView.widthAnchor.constraint(
                equalToConstant: 24
            ),
            closeButtonView.heightAnchor.constraint(
                equalTo: closeButtonView.widthAnchor
            ),
            
            subtitleView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16
            ),
            subtitleView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            ),
            subtitleView.bottomAnchor.constraint(
                equalTo: imageView.bottomAnchor,
                constant: -24
            ),
            
            titleView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16
            ),
            titleView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            ),
            titleView.bottomAnchor.constraint(
                equalTo: subtitleView.topAnchor,
                constant: -16
            )
        ])
    }
}
