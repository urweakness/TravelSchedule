import XCTest
@testable import TravelSchedule


final class TravelScheduleUITests: XCTestCase {
	
	private let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
		app.launch()
    }
	
	@MainActor
	func testTabBarItems() throws {
		let mainButton = app.buttons[
			AccessibilityIdentifier.tabViewMainTabItem.rawValue
		]
		
		let settingsButton = app.buttons[
			AccessibilityIdentifier.tabViewSettingsTabItem.rawValue
		]
		
		// --- tab buttons existance ---
		try testForExistance(mainButton)
		try testForExistance(settingsButton)
		
		// --- settings screen test ---
		settingsButton.tap()
		try testSettingsScreen()
		
		mainButton.tap()
		
		// --- main screen test ---
		try testMainScreen()
	}
}

@MainActor
private extension TravelScheduleUITests {
	func wait(_ seeconds: Int) throws {
		let expectation = XCTestExpectation(description: "Wait for view to load")
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
			expectation.fulfill()
		}
		wait(for: [expectation])
	}
	
	func testForExistance(_ el: XCUIElement, _ exists: Bool = true) throws {
		XCTAssertEqual(
			el.waitForExistence(timeout: 3),
			exists
		)
	}
	
	func testUserAgreementWebView() throws {
		let userAgreementButton = app.images[
			AccessibilityIdentifier.chevronRight.rawValue
		]
		
		try testForExistance(userAgreementButton)
		userAgreementButton.tap()
		
		try wait(3)
		
		let webView = app.webViews.firstMatch
		try testForExistance(webView)
		
		let backButton = app.buttons[
			AccessibilityIdentifier.backButton.rawValue
		]
		
		try testForExistance(backButton)
		backButton.tap()
		try wait(1)
	}
	
	func testSettingsScreen() throws {
		let settingsText = app.staticTexts[
			AccessibilityIdentifier.settingsLabel.rawValue
		]
		
		try testForExistance(settingsText)
		
		// --- theme item ---
		
		// switch
		let switcher = app.switches[
			AccessibilityIdentifier.themeSwitch.rawValue
		]
		
		try testForExistance(switcher)
		try testThemeSwitch(switcher: switcher)
	

		// --- user agreement item ---
		let chevronRight = app.images[
			AccessibilityIdentifier.chevronRight.rawValue
		]
		
		try testForExistance(chevronRight)
		
		// user agreement button
		try testUserAgreementWebView()
		
		// --- about item ---
		// about
		let aboutLabel = app.staticTexts[
			AccessibilityIdentifier.about.rawValue
		]
		
		try testForExistance(aboutLabel)
		
		// version
		let versionLabel = app.staticTexts[
			AccessibilityIdentifier.version.rawValue
		]
		
		try testForExistance(versionLabel)
	}
	
	func testMainScreen() throws {
		// --- routes ---
		let fromLabelID = AccessibilityIdentifier.fromLabel.rawValue
		let toLabelID = AccessibilityIdentifier.toLabel.rawValue
		let switchLabelsButtonID = AccessibilityIdentifier.switchLabelsButton.rawValue
		let findButtonID = AccessibilityIdentifier.findButton.rawValue
		
		let findButton = app.buttons[findButtonID]
		try testForExistance(findButton, false)
		
		let toLabel = app.staticTexts[toLabelID]
		let fromLabel = app.staticTexts[fromLabelID]
		
		try testForExistance(fromLabel)
		fromLabel.tap()
		
		try wait(3)
		
		try tapOnCell(0)
		try tapOnCell(0)

		try testForExistance(toLabel)
		toLabel.tap()
		
		try tapOnCell(1)
		try tapOnCell(0)
		
		let prevFromLabel = fromLabel.label
		let prevToLabel = toLabel.label
		
		let switchLabelsButton = app.buttons[switchLabelsButtonID]
		try testForExistance(switchLabelsButton)
		switchLabelsButton.tap()
		
		try wait(1)
		
		XCTAssertEqual(prevFromLabel, toLabel.label)
		XCTAssertEqual(prevToLabel, fromLabel.label)
		
		try testForExistance(findButton)
		
		// --- stories ---
		try testStories()
	}
	
	func testStories() throws {
		let storiesPreviewScrollID = AccessibilityIdentifier.storiesPreviewScroll.rawValue
		let storiesScrollID = AccessibilityIdentifier.storiesScroll.rawValue
		
		let scroll = app.scrollViews[storiesPreviewScrollID]
		try testForExistance(scroll)
		
		let firstStoryPreview = scroll.buttons.descendants(matching: .any).element(
			boundBy: 0
		)
		try testForExistance(firstStoryPreview)
		
		firstStoryPreview.tap()
		try wait(1)
		
		XCTAssertFalse(firstStoryPreview.isHittable)
		
		let storiesScroll = app.scrollViews[storiesScrollID]
		let firstStory = storiesScroll.otherElements.descendants(matching: .any).element(
			boundBy: 0
		)
		
		firstStory.swipeLeft()
		try wait(1)
		
		firstStory.swipeDown()
		
		XCTAssertTrue(firstStoryPreview.isHittable)
	}
	
	func tapOnCell(_ boundingBy: Int) throws {
		let listView = app.collectionViews[AccessibilityIdentifier.travelPointList.rawValue]
		try testForExistance(listView)
		
		let cell = listView.cells.element(boundBy: boundingBy)
		try testForExistance(cell)
		XCTAssertTrue(cell.isHittable)

		cell.staticTexts.firstMatch.tap()
		try wait(3)
	}
	
	func testThemeSwitch(switcher: XCUIElement) throws {
		// given
		// when
		switcher.tap()
		
		// then
		let _switcher = app.switches[
			AccessibilityIdentifier.themeSwitch.rawValue
		]
		
		XCTAssertNotEqual(switcher, _switcher)
	}
}
