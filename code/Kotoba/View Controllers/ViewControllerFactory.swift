//
//  ViewControllerFactory.swift
//  Kotoba
//
//  Created by Gabor Halasz on 19/07/2018.
//  Copyright © 2018 Will Hains. All rights reserved.
//

import UIKit
import CoreData

final class ViewControllerFactory
{
	static func newWordListViewController(contextProvider: ContextProvider) -> WordListViewController
	{
		let wordListDataSource = WordListDataSource(request: DictionaryQuery.sortedFetchRequest,
													contextProvider: contextProvider)
		let wordListViewController = WordListViewController(dataSource: wordListDataSource)
		wordListDataSource.delegate = wordListViewController
		return wordListViewController
	}
}
