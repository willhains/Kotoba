//
//  Created by Will Hains on 2014-11-24.
//  Copyright (c) 2014 Will Hains. All rights reserved.
//

import UIKit

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
			var words = wordListStore.data
			USER_PREFS.reset()
			words.clear()
		}
		
		debugLog("libraryDirectory = \(NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true))")

		return true
	}

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
