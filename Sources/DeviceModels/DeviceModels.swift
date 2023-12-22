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
		let modelMap: [String: String]
	}
	
	enum DisplayType {
		case OLED
		case MiniLed
		case LCD
	}
	
	func getModelName() async -> String {
		var systemInfo = utsname()
		uname(&systemInfo)
		let modelCode = withUnsafePointer(to: &systemInfo.machine) {
			$0.withMemoryRebound(to: CChar.self, capacity: 1) {
				ptr in String.init(validatingUTF8: ptr)
			}
		}
		
		guard let modelCode else {
			return "unknown"
		}
		
		// Load modelMap from "https://confuseious.github.io/DeviceModels/data.json"
		var request = URLRequest(url: URL(string: "https://confuseious.github.io/DeviceModels/data.json")!)
		request.httpMethod = "GET"
		
		do {
			let (data, _) = try await URLSession.shared.data(for: request)
			let modelMap = try JSONDecoder().decode(ModelMapResponse.self, from: data).modelMap
			
			if let model = modelMap.first(where: { $0.key == modelCode })?.value {
				print("modelCode: \(modelCode)")
				print("model: \(model)")
				if model == "simulator" {
					if let simModelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
						if let simModel = modelMap.first(where: { $0.key == simModelCode })?.value {
							return simModel
						}
					}
				}
				return model
			}
		} catch let e {
			print("Catch block")
			print(e)
			return "unknown"
		}
		
		return "unknown"
	}

	func getDeviceType() async -> String {
		// iPhoneX refers to devices with a notch.
		// iPhonePill refers to iPhones with a dynamic island.
		// iPadX refers to iPads with no home button.
		let modelName = await getModelName()
		
		switch modelName {
		case "iPhone SE", "iPhone SE (2nd Generation)", "iPhone SE (3rd Generation)",
			"iPhone 6s", "iPhone 6s Plus",
			"iPhone 7", "iPhone 7 Plus",
			"iPhone 8", "iPhone 8 Plus",
			"iPod touch (1st generation)", "iPod touch (2nd generation)", "iPod touch (3rd generation)", "iPod touch (4th generation)", "iPod touch (5th generation)", "iPod touch (6th generation)", "iPod touch (7th generation)":
			return "iPhone"
		case "iPhone X",
			"iPhone XR", "iPhone XS", "iPhone XS Max",
			"iPhone 11", "iPhone 11 Pro", "iPhone 11 Pro Max",
			"iPhone 12", "iPhone 12 mini", "iPhone 12 Pro", "iPhone 12 Pro Max",
			"iPhone 13", "iPhone 13 mini", "iPhone 13 Pro", "iPhone 13 Pro Max",
			"iPhone 14", "iPhone 14 Plus":
			return "iPhoneX"
		case "iPhone 14 Pro", "iPhone 14 Pro Max",
			"iPhone 15", "iPhone 15 Plus", "iPhone 15 Pro", "iPhone 15 Pro Max":
			return "iPhonePill"
		case "iPad 2", "iPad (3rd generation)", "iPad (4th generation)", "iPad (5th generation)", "iPad6th generation)", "iPad (7th generation)", "iPad (8th generation)", "iPad (9th generation)",
			"iPad Air", "iPad Air 2", "iPad Air (3rd generation)",
			"iPad mini", "iPad mini 2", "iPad mini 3", "iPad mini 4", "iPad mini (5th generation)",
			"iPad Pro (9.7-inch)", "iPad Pro (10.5-inch)", "iPad Pro (12.9-inch)", "iPad Pro (12.9-inch) (2nd generation)":
			return "iPad"
		case "iPad mini (6th generation)",
			"iPad Air (4th generation)", "iPad Air (5th generation)",
			"iPad Pro (11-inch)", "iPad Pro (11-inch) (2nd generation)", "iPad Pro (11-inch) (3rd generation)", "iPad Pro (11-inch) (4th generation)",
			"iPad Pro (12.9-inch) (3rd generation)", "iPad Pro (12.9-inch) (4th generation)", "iPad Pro (12.9-inch) (5th generation)", "iPad Pro (12.9-inch) (6th generation)":
			return "iPadX"
		default:
			print("Default Case")
			return "iPhone"
		}
	}

	func getDisplayType() async -> DisplayType {
		let modelName = await getModelName()
		
		switch modelName {
		case "iPhone X", "iPhone XS", "iPhone XS Max", "iPhone 11 Pro", "iPhone 11 Pro Max", "iPhone 12", "iPhone 12 mini", "iPhone 12 Pro", "iPhone 12 Pro Max", "iPhone 13", "iPhone 13 mini", "iPhone 13 Pro", "iPhone 13 Pro Max", "iPhone 14", "iPhone 14 Plus", "iPhone 14 Pro", "iPhone 14 Pro Max":
			return .OLED
		case "iPad Pro (5th generation)", "iPad Pro (6th generation)":
			return .MiniLed
		default:
			return .LCD
		}
	}
}
#endif
#endif
