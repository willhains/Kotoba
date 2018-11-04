//
//  DatabaseMigrator.swift
//  Kotoba
//
//  Created by Gabor Halasz on 18/07/2018.
//  Copyright © 2018 Will Hains. All rights reserved.
//

import CoreData

protocol DatabaseMigrator
{
	var isMigrationRequired: Bool { get }
	func migrateDatabase(
		inContext context: NSManagedObjectContext,
		completion: @escaping () -> Void)
}

final class Migrator: DatabaseMigrator
{
	var isMigrationRequired: Bool
	{
		return words.count > 0
	}
	
	func migrateDatabase(
		inContext context: NSManagedObjectContext,
		completion: @escaping () -> Void)
	{
		DispatchQueue.global(qos: .default).async
		{
			context.makeChanges
			{
				[weak self, unowned context] in
				for oldWordEntry in words.allWords()
				{
					let newWord: DictionaryQuery = context.insertObject()
					newWord.word = oldWordEntry.trimmingCharacters(in: .whitespacesAndNewlines)
				}
				self?.removeOldDatabaseEntries()
				DispatchQueue.main.async
				{
					completion()
				}
			}
		}
	}
	
	private func removeOldDatabaseEntries()
	{
		words.clear()
	}
}
