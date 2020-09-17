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
			case .local: return UserDefaults(suiteName: APP_GROUP_ID)!
			case .iCloud: return NSUbiquitousKeyValueStore.default;
		}
	}

	func synchroniseStores()
	{
		// Merge local history with iCloud history
		debugLog("Synchronise/merge local and iCloud word stores")
		// TODO: Code duplicated above.
		var local: WordListStrings = UserDefaults(suiteName: APP_GROUP_ID)!
		var cloud: WordListStrings = NSUbiquitousKeyValueStore.default
		debugLog("add: BEFORE local=\(local.wordStrings.first ?? "")..\(local.wordStrings.last ?? "")")
		debugLog("add: BEFORE cloud=\(cloud.wordStrings.first ?? "")..\(cloud.wordStrings.last ?? "")")
		for word in local.wordStrings where !cloud.wordStrings.contains(word)
		{
			cloud.wordStrings.insert(word, at: 0)
		}
		local.wordStrings = cloud.wordStrings
		debugLog("add: AFTER local=\(local.wordStrings.first ?? "")..\(local.wordStrings.last ?? "")")
		debugLog("add: AFTER cloud=\(cloud.wordStrings.first ?? "")..\(cloud.wordStrings.last ?? "")")
	}
}

/// Current selection of word list store.
var wordListStore: WordListStore
{
	get { NSUbiquitousKeyValueStore.iCloudEnabledInSettings ? .iCloud : .local }
	set { newValue.synchroniseStores() }
}
