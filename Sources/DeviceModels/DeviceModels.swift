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
	
	
	//	func checkDeviceType() -> String {
	//		switch UIDevice().type {
	//		case .iPhoneSE, .iPhone6S, .iPhone6SPlus, .iPhone7, .iPhone7Plus, .iPhone8, .iPhone8Plus, .iPhoneSE2, .iPhoneSE3, .iPod1, .iPod2, .iPod3, .iPod4, .iPod5, .iPod6, .iPod7:
	//			return "iPhone"
	//		case .iPhoneX, .iPhoneXR, .iPhoneXS, .iPhoneXSMax, .iPhone11, .iPhone11Pro, .iPhone11ProMax, .iPhone12, .iPhone12Mini, .iPhone12Pro, .iPhone12ProMax, .iPhone13, .iPhone13Mini, .iPhone13Pro, .iPhone13ProMax, .iPhone14, .iPhone14Plus:
	//			return "iPhoneX"
	//		case .iPhone14Pro, .iPhone14ProMax, .iPhone15, .iPhone15Plus, .iPhone15Pro, .iPhone15ProMax:
	//			return "iPhonePill"
	//		case .iPad2, .iPad3, .iPad4, .iPad5, .iPad6, .iPad7, .iPad8, .iPad9, .iPadAir, .iPadAir2, .iPadAir3, .iPadMini, .iPadMini2, .iPadMini3, .iPadMini4, .iPadMini5, .iPadPro9_7, .iPadPro10_5, .iPadPro12_9, .iPadPro2_12_9:
	//			return "iPad"
	//		case .iPadAir4, .iPadAir5, .iPadPro11, .iPadPro2_11, .iPadPro3_12_9, .iPadPro3_11, .iPadPro4_11, .iPadPro4_12_9, .iPadPro5_12_9, .iPadPro6_12_9, .iPadMini6:
	//			return "iPadX"
	//		default:
	//			print("Default Case")
	//			return "iPhone"
	//		}
	//	}
	//
	//
	//	func displayType() -> DisplayType {
	//		switch UIDevice().type {
	//		case .iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhone11Pro, .iPhone11ProMax, .iPhone12, .iPhone12Mini, .iPhone12Pro, .iPhone12ProMax, .iPhone13, .iPhone13Mini, .iPhone13Pro, .iPhone13ProMax, .iPhone14, .iPhone14Plus, .iPhone14Pro, .iPhone14ProMax:
	//			return .OLED
	//		case .iPadPro5_12_9, .iPadPro6_12_9:
	//			return .MiniLed
	//		default:
	//			return .LCD
	//		}
	//	}
}
#endif
#endif
