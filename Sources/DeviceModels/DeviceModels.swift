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

public enum Model : String {
	
	// Simulator
	case simulator     = "simulator/sandbox",
		 
		 // iPod
		 iPod1              = "iPod 1",
		 iPod2              = "iPod 2",
		 iPod3              = "iPod 3",
		 iPod4              = "iPod 4",
		 iPod5              = "iPod 5",
		 iPod6              = "iPod 6",
		 iPod7              = "iPod 7",
		 
		 // iPad
		 iPad2              = "iPad 2",
		 iPad3              = "iPad 3",
		 iPad4              = "iPad 4",
		 iPad5              = "iPad 5", //iPad 2017
		 iPad6              = "iPad 6", //iPad 2018
		 iPad7              = "iPad 7", //iPad 2019
		 iPad8              = "iPad 8", //iPad 2020
		 iPad9              = "iPad 9", //iPad 2021
		 
		 // iPad Air
		 iPadAir            = "iPad Air ",
		 iPadAir2           = "iPad Air 2",
		 iPadAir3           = "iPad Air 3",
		 iPadAir4           = "iPad Air 4",
		 iPadAir5           = "iPad Air 5",
		 
		 // iPad Mini
		 iPadMini           = "iPad Mini",
		 iPadMini2          = "iPad Mini 2",
		 iPadMini3          = "iPad Mini 3",
		 iPadMini4          = "iPad Mini 4",
		 iPadMini5          = "iPad Mini 5",
		 iPadMini6          = "iPad Mini 6",
		 
		 // iPad Pro
		 iPadPro9_7         = "iPad Pro 9.7\"",
		 iPadPro10_5        = "iPad Pro 10.5\"",
		 iPadPro11          = "iPad Pro 11\"",
		 iPadPro2_11        = "iPad Pro 11\" 2nd gen",
		 iPadPro3_11        = "iPad Pro 11\" 3nd gen",
		 iPadPro12_9        = "iPad Pro 12.9\"",
		 iPadPro2_12_9      = "iPad Pro 2 12.9\"",
		 iPadPro3_12_9      = "iPad Pro 3 12.9\"",
		 iPadPro4_11        = "iPad Pro 4 11\"",
		 iPadPro4_12_9      = "iPad Pro 4 12.9\"",
		 iPadPro5_12_9      = "iPad Pro 5 12.9\"",
		 iPadPro6_12_9      = "iPad Pro 6 12.9\"",
		 
		 // iPhone
		 iPhone4            = "iPhone 4",
		 iPhone4S           = "iPhone 4S",
		 iPhone5            = "iPhone 5",
		 iPhone5S           = "iPhone 5S",
		 iPhone5C           = "iPhone 5C",
		 iPhone6            = "iPhone 6",
		 iPhone6Plus        = "iPhone 6 Plus",
		 iPhone6S           = "iPhone 6S",
		 iPhone6SPlus       = "iPhone 6S Plus",
		 iPhoneSE           = "iPhone SE",
		 iPhone7            = "iPhone 7",
		 iPhone7Plus        = "iPhone 7 Plus",
		 iPhone8            = "iPhone 8",
		 iPhone8Plus        = "iPhone 8 Plus",
		 iPhoneX            = "iPhone X",
		 iPhoneXS           = "iPhone XS",
		 iPhoneXSMax        = "iPhone XS Max",
		 iPhoneXR           = "iPhone XR",
		 iPhone11           = "iPhone 11",
		 iPhone11Pro        = "iPhone 11 Pro",
		 iPhone11ProMax     = "iPhone 11 Pro Max",
		 iPhoneSE2          = "iPhone SE (2nd Generation)",
		 iPhone12Mini       = "iPhone 12 Mini",
		 iPhone12           = "iPhone 12",
		 iPhone12Pro        = "iPhone 12 Pro",
		 iPhone12ProMax     = "iPhone 12 Pro Max",
		 iPhone13Mini       = "iPhone 13 Mini",
		 iPhone13           = "iPhone 13",
		 iPhone13Pro        = "iPhone 13 Pro",
		 iPhone13ProMax     = "iPhone 13 Pro Max",
		 iPhoneSE3          = "iPhone SE (3rd Generation)",
		 iPhone14           = "iPhone 14",
		 iPhone14Plus       = "iPhone 14 Plus",
		 iPhone14Pro        = "iPhone 14 Pro",
		 iPhone14ProMax     = "iPhone 14 Pro Max",
		 iPhone15 			= "iPhone 15",
		 iPhone15Plus 		= "iPhone 15 Plus",
		 iPhone15Pro 		= "iPhone 15 Pro",
		 iPhone15ProMax 	= "iPhone 15 Pro Max",
		 unrecognized       = "?unrecognized?"
}

// #-#-#-#-#-#-#-#-#-#-#-#-#
// MARK: UIDevice extensions
// #-#-#-#-#-#-#-#-#-#-#-#-#

public extension UIDevice {
	
	enum DisplayType {
		case OLED
		case MiniLed
		case LCD
	}
	
	var type: Model {
		var systemInfo = utsname()
		uname(&systemInfo)
		let modelCode = withUnsafePointer(to: &systemInfo.machine) {
			$0.withMemoryRebound(to: CChar.self, capacity: 1) {
				ptr in String.init(validatingUTF8: ptr)
			}
		}
		
		// Load modelMap from 
		
		if let modelCode = modelCode, let model = modelMap[modelCode] {
			if model == .simulator {
				if let simModelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
					if let simModel = modelMap[simModelCode] {
						return simModel
					}
				}
			}
			return model
		}
		return Model.unrecognized
	}
	
	func checkDeviceType() -> String {
		switch UIDevice().type {
		case .iPhoneSE, .iPhone6S, .iPhone6SPlus, .iPhone7, .iPhone7Plus, .iPhone8, .iPhone8Plus, .iPhoneSE2, .iPhoneSE3, .iPod1, .iPod2, .iPod3, .iPod4, .iPod5, .iPod6, .iPod7:
			return "iPhone"
		case .iPhoneX, .iPhoneXR, .iPhoneXS, .iPhoneXSMax, .iPhone11, .iPhone11Pro, .iPhone11ProMax, .iPhone12, .iPhone12Mini, .iPhone12Pro, .iPhone12ProMax, .iPhone13, .iPhone13Mini, .iPhone13Pro, .iPhone13ProMax, .iPhone14, .iPhone14Plus:
			return "iPhoneX"
		case .iPhone14Pro, .iPhone14ProMax, .iPhone15, .iPhone15Plus, .iPhone15Pro, .iPhone15ProMax:
			return "iPhonePill"
		case .iPad2, .iPad3, .iPad4, .iPad5, .iPad6, .iPad7, .iPad8, .iPad9, .iPadAir, .iPadAir2, .iPadAir3, .iPadMini, .iPadMini2, .iPadMini3, .iPadMini4, .iPadMini5, .iPadPro9_7, .iPadPro10_5, .iPadPro12_9, .iPadPro2_12_9:
			return "iPad"
		case .iPadAir4, .iPadAir5, .iPadPro11, .iPadPro2_11, .iPadPro3_12_9, .iPadPro3_11, .iPadPro4_11, .iPadPro4_12_9, .iPadPro5_12_9, .iPadPro6_12_9, .iPadMini6:
			return "iPadX"
		default:
			print("Default Case")
			return "iPhone"
		}
	}
	
	
	func displayType() -> DisplayType {
		switch UIDevice().type {
		case .iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhone11Pro, .iPhone11ProMax, .iPhone12, .iPhone12Mini, .iPhone12Pro, .iPhone12ProMax, .iPhone13, .iPhone13Mini, .iPhone13Pro, .iPhone13ProMax, .iPhone14, .iPhone14Plus, .iPhone14Pro, .iPhone14ProMax:
			return .OLED
		case .iPadPro5_12_9, .iPadPro6_12_9:
			return .MiniLed
		default:
			return .LCD
		}
	}
}
#endif
#endif
