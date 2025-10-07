import SwiftUI

@MainActor
@Observable
final class DataCoordinator {
	let loader = Loader()
	@ObservationIgnored
	let dataFetcher = DataFetcher()
}

// MARK: - DataCoordinator Extensions

// --- methods ---
extension DataCoordinator {
	// --- getStationsList ---
	func getStationsList(format: Format = .json) async throws -> AllStationsResponse {
		try await loader.fetchData {
			try await self.dataFetcher
				.getStationsList(
					format: format
				)
		}
	}
	
	// --- getThreadStations ---
	func getThreadStations(by uid: String) async throws -> ThreadStationsResponse {
		try await loader.fetchData {
			try await self.dataFetcher
				.getThreadStations(
					by: uid
				)
		}
	}
	
	// --- getStationSchedule ---
	func getStationSchedule(station: String) async throws -> ScheduleResponse {
		try await loader.fetchData {
			try await self.dataFetcher
				.getStationSchedule(
					station: station
				)
		}
	}
	
	// --- getNearestStations ---
	func getNearestStations(
		lat: Double,
		lng: Double,
		distance: Int
	) async throws -> NearestStations {
		try await loader.fetchData {
			try await self.dataFetcher
				.getNearestStations(
					lat: lat,
					lng: lng,
					distance: distance
				)
		}
	}
	
	// --- getScheduleBetweenStations ---
	func getScheduleBetweenStations(
		from: String,
		to: String
	) async throws -> ScheduleBetweenStationsResponse {
		try await loader.fetchData {
			try await self.dataFetcher
				.getScheduleBetweenStations(
					from: from,
					to: to
				)
		}
	}
	
	// --- getCopyright ---
	func getCopyright() async throws -> CopyrightResponse {
		try await loader.fetchData {
			try await self.dataFetcher
				.getCopyright()
		}
	}
	
	// --- getNearestCity ---
	func getNearestCity(
		lat: Double,
		lng: Double
	) async throws -> NearestCityResponse {
		try await loader.fetchData {
			try await self.dataFetcher
				.getNearestCity(
					lat: lat,
					lng: lng
				)
		}
	}
	
	// --- getCarrierInfo ---
	func getCarrierInfo(
		carrierCode: String,
		codingSystem: CodingSystem
	) async throws -> CarrierJsonPayload {
		try await loader.fetchData {
			try await self.dataFetcher
				.getCarrierInfo(
					carrierCode: carrierCode,
					codingSystem: codingSystem
				)
		}
	}
}
