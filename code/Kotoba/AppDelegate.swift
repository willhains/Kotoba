//
//  AppDelegate.swift
//  Kotoba
//
//  Created by Will Hains on 2014-11-24.
//  Copyright (c) 2014 Will Hains. All rights reserved.
//

import UIKit

/// Theme colour for app icon and tint
private let _redThemeColour = UIColourTheme(hue: 5.0, saturation: 0.73, brightness: 0.65)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
	var window: UIWindow?
	
	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil)
		-> Bool
	{
		// Reset user defaults for UI tests
		if options.appMode == .testing
		{
			prefs.reset()
			words.clear()
		}
		
		// Set tint colour to match icon
		_redThemeColour.applyTint()
		return true
	}
}
