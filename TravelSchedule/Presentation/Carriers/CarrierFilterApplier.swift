import Foundation

@MainActor
final class CarrierFilterApplier {
	// --- applying filter to carrier model ---
	func applyFilterToCarrierModel(
		_ carrierModel: CarrierModel,
		filter: FilterModel?
	) -> CarrierModel? {
		guard let filter else {
			return carrierModel
		}
		
		// --- transfers filter ---
		let matchesTransfers: Bool = {
			guard let allow = filter.allowTransfers else { return true }
			return allow == (carrierModel.transferInfo != nil)
		}()
		
		// --- depart time windows ---
		let matchesDepartFilter: Bool = {
			let selectedWindows = filter.departFilter
			guard !selectedWindows.isEmpty else { return true }
			
			// -- using string depart time "HH:mm"
			guard let comparedMinutes = parseHHmm(carrierModel.startTime) else {
				return true
			}
			
			return selectedWindows.contains { departFilter in
				let bounds = departFilter.time // (leftBound: String, rightBound: String)
				return isInTimeBounds(filter: bounds, comparedMinutes: comparedMinutes)
			}
		}()
		
		let matchesFilters = matchesDepartFilter && matchesTransfers
		return matchesFilters ? carrierModel : nil
	}
	
	// --- depart time bounds checker ---
	// intervals are halfopened: [left, right]
	// example, 00:00 don't confirms "18:00–00:00", but confirming "00:00–06:00"
	private func isInTimeBounds(
		filter: (leftBound: String, rightBound: String),
		comparedMinutes: Int
	) -> Bool {
		guard
			let left = parseHHmm(filter.leftBound),
			let right = parseHHmm(filter.rightBound)
		else {
			return false
		}
		
		// normal interval (not throw the midnight): [left, right]
		if left <= right {
			return comparedMinutes >= left && comparedMinutes < right
		}
		
		// interval throw midnight, for intance 22:00–06:00: [left, 24h) U [0, right)
		return comparedMinutes >= left || comparedMinutes < right
	}
	
	// --- helpers ---
	private func parseHHmm(_ string: String) -> Int? {
		let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
		let parts = trimmed.split(
			separator: ":",
			maxSplits: 1,
			omittingEmptySubsequences: false
		)
		guard
			parts.count == 2,
			let h = Int(parts[0]),
			let m = Int(parts[1]),
			(0...23).contains(h),
			(0...59).contains(m)
		else {
			return nil
		}
		return h * 60 + m
	}
}
