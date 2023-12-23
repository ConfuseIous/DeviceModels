//
//  DeviceModels.swift
//  PowerToYou
//
//  Created by Karandeep Singh on 3/1/22.
//

#if canImport(UIKit)
#if os(iOS)

import UIKit
import Foundation

public extension UIDevice {
	
	private struct ModelMapResponse: Codable {
		let modelMap: [String: [String: String]]
	}
	
	struct DeviceDetails {
		var modelName: String
		var deviceType: String
	}

	func getDeviceDetails() async -> DeviceDetails? {
		var systemInfo = utsname()
		uname(&systemInfo)
		let modelCode = withUnsafePointer(to: &systemInfo.machine) {
			$0.withMemoryRebound(to: CChar.self, capacity: 1) {
				ptr in String.init(validatingUTF8: ptr)
			}
		}
		
		guard let modelCode else {
			return nil
		}
		
		// Load modelMap from "https://confuseious.github.io/DeviceModels/data.json"
		var request = URLRequest(url: URL(string: "https://confuseious.github.io/DeviceModels/data.json")!)
		request.httpMethod = "GET"
		
		do {
			let (data, _) = try await URLSession.shared.data(for: request)
			let modelMap = try JSONDecoder().decode(ModelMapResponse.self, from: data).modelMap
			
			if let model = modelMap.first(where: { $0.key == modelCode })?.value {
				return DeviceDetails(modelName: model["name"] ?? "unknown", deviceType: model["type"] ?? "unknown")
			} else {
				print("🐛 DeviceModels: getDeviceDetails(): Model not found")
				return nil
			}
		} catch let e {
			print("🐛 DeviceModels: getDeviceDetails(): \(e.localizedDescription)")
			return nil
		}
	}
}
#endif
#endif

