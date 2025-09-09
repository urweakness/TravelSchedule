import SwiftUI

struct StoryViewRepresentable: UIViewRepresentable {
    var stories: [StoryModel] = stubStories
    let screenSize: CGSize
    
    func makeUIView(context: Context) -> UIView {
        let uiView = StoryUIKitView(frame: .init(origin: .zero, size: screenSize))
        uiView.stories = stories
        uiView.currentStoryIndex = 0
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
    var stories: [StoryModel]?
    var currentStoryIndex: Int?
    
    lazy var timelineView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var closeButtonView: UIButton = {
        let view = UIButton(type: .custom)
        view.setImage(UIImage(systemName: "xmark"), for: .normal)
        view.tintColor = .white
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        if
            let currentStoryIndex,
            let fullImageResource = stories?[safe: currentStoryIndex]?.fullImageResource
        {
            view.image = UIImage(resource: fullImageResource)
            view.layer.cornerRadius = 60
        }
        return view
    }()
    
    lazy var titleView: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.textColor = .white
        view.numberOfLines = 3
        if
            let currentStoryIndex,
            let title = stories?[safe: currentStoryIndex]?.title
        {
            view.text = title
        }
        return view
    }()
    
    lazy var subtitleView: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 17, weight: .regular)
        view.textColor = .white
        view.numberOfLines = 3
        if
            let currentStoryIndex,
            let subtitle = stories?[safe: currentStoryIndex]?.description
        {
            view.text = subtitle
        }
        return view
    }()
    
    override func didMoveToWindow() {
        backgroundColor = .travelWhite
        
        activateTimelineConstraints()
        activateConstriants()
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
        
        var previousXAxisAnchor: NSLayoutXAxisAnchor?
        
        stories?.forEach {
            let timelineItemView = UIActivityIndicatorView(style: .large)
            timelineItemView.color = .travelBlue
            timelineItemView.backgroundColor = .white
            timelineItemView.accessibilityIdentifier = "\($0.id)"
            
            timelineItemView.translatesAutoresizingMaskIntoConstraints = false
            
            timelineView.addSubview(timelineItemView)
            
            NSLayoutConstraint.activate([
                timelineItemView.topAnchor.constraint(
                    equalTo: timelineView.topAnchor
                ),
                timelineItemView.bottomAnchor.constraint(
                    equalTo: timelineView.bottomAnchor
                ),
                timelineItemView.heightAnchor.constraint(
                    equalToConstant: 6
                ),
                timelineItemView.widthAnchor.constraint(
                    equalToConstant: bounds.width / CGFloat(stories?.count ?? 1)
                ),
                timelineItemView.leadingAnchor.constraint(
                    equalTo: previousXAxisAnchor ?? timelineView.leadingAnchor,
                    constant: 8
                )
            ])
            
            previousXAxisAnchor = timelineItemView.leadingAnchor
        }
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
