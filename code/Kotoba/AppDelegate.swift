//
//  AppDelegate.swift
//  Kotoba
//
//  Created by Will Hains on 2014-11-24.
//  Copyright (c) 2014 Will Hains. All rights reserved.
//

import UIKit

// Theme colour for app icon and tint
let redThemeColour = UIColor(named: "appTint") ?? UIColor(hue: 5.0, saturation: 0.73, brightness: 0.65, alpha: 1.0)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
	var window: UIWindow?
	
	func application(
		_ application: UIApplication,
		willFinishLaunchingWithOptions
		launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool
	{
		return true
	}
	
	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil)
		-> Bool
	{
		// Reset user defaults for UI tests
		if ProcessInfo.processInfo.arguments.contains("UITEST")
		{
			var words = wordListStore.data
			prefs.reset()
			words.clear()
		}
		
		debugLog("libraryDirectory = \(NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true))")
		
		// Set tint colour to match icon
		UIView.appearance().tintColor = redThemeColour
		return true
	}
}
