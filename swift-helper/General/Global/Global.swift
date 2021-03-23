//
//  Global.swift
//  swift-helper
//
//  Created by Tung Xuan on 3/23/21.
//

import Foundation
import UIKit

struct Global {
	
	struct Constant {
		static let navBarHeight = UINavigationBar().frame.size.height > 0 ? UINavigationBar().frame.size.height : 44
		static let screenWidth = UIScreen.main.bounds.size.width
		static let screenHeight = UIScreen.main.bounds.size.height
		static let screenScale = UIScreen.main.scale
		
		static var window: UIWindow? {
			return UIApplication.shared.windows.filter {$0.isKeyWindow}.first
		}
		
		static var statusBarHeight: CGFloat {
			return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 20
		}
		
		static var bottomPadding: CGFloat {
			return window?.safeAreaInsets.bottom ?? 0
		}
		
		static let decoder = JSONDecoder()
	}
	
	struct API_Constants {
		static let kUrlApi = "https://tungxuan.com/api"
	}
	
	static var appLanguage: String {
		get { return UserDefaults.standard.value(forKey: "kSavedAppLanguage") as? String ?? "en" }
		set { UserDefaults.standard.set(newValue, forKey: "kSavedAppLanguage") }
	}
}
