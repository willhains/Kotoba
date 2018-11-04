//
//  AppDelegate.swift
//  Kotoba
//
//  Created by Will Hains on 2014-11-24.
//  Copyright (c) 2014 Will Hains. All rights reserved.
//

import UIKit

// Theme colour for app icon and tint
let redThemeColor = UIColor(hue: 5.0, saturation: 0.73, brightness: 0.65, alpha: 1.0)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
	var window: UIWindow?
	var stackManager: CoreDataStackManager!
	
	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil)
		-> Bool
	{
		stackManager = CoreDataStackManager(modelName: "Kotoba")
		{
			success in
			if !success { print("Could not initialise CoreData stack") }
		}
		
		migrateDatabaseIfRequired()
		setContextProvider()
		
		// Reset user defaults for UI tests
		if ProcessInfo.processInfo.arguments.contains("UITEST")
		{
			prefs.reset()
			words.clear()
		}
		
		// Set tint colour to match icon
		UIView.appearance().tintColor = redThemeColor
		return true
	}
}

extension AppDelegate
{
	func migrateDatabaseIfRequired()
	{
		let migrator = Migrator()
		if migrator.isMigrationRequired
		{
			// WH: Unfinished? Or perhaps raise a separate issue for this one, and implement it later.
			// TODO: present activity indicator to user
			migrator.migrateDatabase(inContext: stackManager.backgroundContext)
			{
				// TODO: remove activity indicator
			}
		}
	}
}

extension AppDelegate
{
	func setContextProvider()
	{
		let navigationController = window!.rootViewController as! UINavigationController
		let addWordViewController = navigationController.topViewController! as! AddWordViewController
		addWordViewController.contextProvider = stackManager
	}
}
