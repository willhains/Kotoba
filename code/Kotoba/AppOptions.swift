//
//  AppOptions.swift
//  Kotoba
//
//  Created by Will Hains on 2018-10-13.
//  Copyright © 2018 Will Hains. All rights reserved.
//

import Foundation

/// Launch options for the app, which can be set in the scheme
protocol AppOptions
{
	/// Which mode to start the app in
	var appMode: AppMode { get }
}

enum AppMode
{
	/// App is being used interactively by a user (production).
	case user
	
	/// App is being tested by Xcode.
	case testing
}

// MARK:- Expose ProcessInfo arguments via AppOptions
extension ProcessInfo: AppOptions
{
	var appMode: AppMode
	{
		if arguments.contains("UITEST") { return .testing }
		return .user
	}
}

/// `AppOptions` backed by `ProcessInfo.processInfo`
let options: AppOptions = ProcessInfo.processInfo
