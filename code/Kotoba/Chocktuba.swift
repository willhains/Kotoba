//
// Created by Will Hains on 2020-06-21.
// Copyright (c) 2020 Will Hains. All rights reserved.
//

import Foundation

private let _CHOCKTUBA_DUH = "FIXTHISAPP"

extension UserDefaults
{
	var CHOCKTUBA_DUH: Bool
	{
		get
		{
			//return true
			return bool(forKey: _CHOCKTUBA_DUH)
		}
		set
		{
			set(newValue, forKey: _CHOCKTUBA_DUH)
		}
	}
}
