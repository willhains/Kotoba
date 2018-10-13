//
//  AppOptions.swift
//  Kotoba
//
//  Created by Will Hains on 2018-10-13.
//  Copyright © 2018 Will Hains. All rights reserved.
//

import Foundation

protocol AppOptions
{
	var appMode: AppMode { get }
}

enum AppMode
{
	case user
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

let options: AppOptions = ProcessInfo.processInfo
