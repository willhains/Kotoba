//
//  Workarounds.swift
//  Kotoba
//
//  Created by Troy Gaul on 6/20/18.
//  Copyright © 2018 Will Hains. All rights reserved.
//

import Foundation

extension NSDictionary
{
	// iOS 12 beta apparently has a crash (exception) where UIDictionaryManager tries to access
	// a property via _isTTYEnabled that it expects to be a value (String or Number), probably
	// from some dictionary somewhere, that it can turn into a Bool by calling boolValue, but on
	// this OS version, the value it's getting back is a dictionary.  This workaround fixes that
	// by implementing that method in an extension of NSDictionary to always return false.  This
	// should be removed in the future if it's not needed because the underlying code is fixed.

	@objc func boolValue() -> Bool
    {
		return false
	}
}
