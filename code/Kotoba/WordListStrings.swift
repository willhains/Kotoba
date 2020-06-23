//
// Created by Will Hains on 2020-06-23.
// Copyright (c) 2020 Will Hains. All rights reserved.
//

import Foundation

/// Internal persistence of word list as an array of strings.
protocol WordListStrings
{
	var wordStrings: [String]
	{
		get set
	}
}
