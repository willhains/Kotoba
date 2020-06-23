//
//  WordList.swift
//  Words
//
//  Created by Will Hains on 2016-06-05.
//  Copyright © 2016 Will Hains. All rights reserved.
//

import UIKit

/// Choices for where to store the word list.
enum WordListStore
{
	case local
	case iCloud
	
	var data: WordListDataSource
	{
		switch self
		{
			case .local: return UserDefaults.init(suiteName: APP_GROUP_ID)!
			case .iCloud: return NSUbiquitousKeyValueStore.default;
		}
	}
}

/// Current selection of word list store.
var wordListStore: WordListStore
{
	get { NSUbiquitousKeyValueStore.iCloudEnabledInSettings ? .iCloud : .local }
	
	set
	{
		// Merge local history with iCloud history
		var local: WordListStrings = UserDefaults.init(suiteName: APP_GROUP_ID)!
		var cloud: WordListStrings = NSUbiquitousKeyValueStore.default
		for word in local.wordStrings where !cloud.wordStrings.contains(word)
		{
			cloud.wordStrings.insert(word, at: 0)
		}
		local.wordStrings = cloud.wordStrings
	}
}
