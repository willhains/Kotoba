//
//  WordList.swift
//  Words
//
//  Created by Will Hains on 2016-06-05.
//  Copyright © 2016 Will Hains. All rights reserved.
//

import UIKit

// NOTE: WordListStore used to be an enum that supported both local and iCloud storage, but there's really only one data source now: iCloud.
// (If a user isn't signed into iCloud, the ubiquitous key value store behaves like user defaults. An extension can also access the same data.)
//
// To simplify this refactor, WordListStore is now a struct that returns a single data source.

/// Where to store the word list.
struct WordListStore
{
	var data: WordListDataSource
	{
		return NSUbiquitousKeyValueStore.default
	}
}

/// Current selection of word list store.
var wordListStore = WordListStore()
