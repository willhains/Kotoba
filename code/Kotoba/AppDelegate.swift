//
//  Created by Will Hains on 2014-11-24.
//  Copyright (c) 2014 Will Hains. All rights reserved.
//

import UIKit

// Theme colour for app icon and tint
private let _RED_THEME_COLOUR = UIColor(named: "appTint")
	?? UIColor(hue: 5.0, saturation: 0.73, brightness: 0.65, alpha: 1.0)

// App group ID
let APP_GROUP_ID = "group.com.willhains.Kotoba"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
	var window: UIWindow?

	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
	{
		// Reset user defaults for UI tests
		if ProcessInfo.processInfo.arguments.contains("UITEST")
		{
			wordListStore = .local
			var words = wordListStore.data
			USER_PREFS.reset()
			words.clear()
		}

		debugLog("libraryDirectory = \(NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true))")

		// Set tint colour to match icon
		UIView.appearance().tintColor = _RED_THEME_COLOUR
		return true
	}

	func applicationWillEnterForeground(_ application: UIApplication)
	{
		// Migrate to/from iCloud
		wordListStore.synchroniseStores()
	}
}
