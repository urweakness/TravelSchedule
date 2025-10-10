import XCTest
@testable import TravelSchedule

final class DataCoordinatorTests: XCTestCase {
	
	func testStationListServiceResponse() async {
		let manager = await DataCoordinator()
		let response = try? await manager.getStationsList()
		
		XCTAssertNotNil(response?.countries)
		XCTAssertNotNil(
			response?.countries?.first(where: { $0.title == "Россия" })
		)
	}
	
	func testScheduleBetweenStationsServiceResponse() async {
		let manager = await DataCoordinator()
		let firstResponse = try? await manager.getScheduleBetweenStations(
			from: "s9600213",
			to: "c146"
		)
		let secondResponse = try? await manager.getScheduleBetweenStations(
			from: "XXX",
			to: "XXX"
		)
		
		XCTAssertNotNil(firstResponse)
		XCTAssertNil(secondResponse)
		
		XCTAssertNotNil(firstResponse?.segments)
	}
	
}
