//
//  DatabaseMigrator.swift
//  Kotoba
//
//  Created by Gabor Halasz on 18/07/2018.
//  Copyright © 2018 Will Hains. All rights reserved.
//

import Foundation
import CoreData

protocol DatabaseMigrator {
	static var isMigrationRequired: Bool { get }
	static func migrateDatabase(inContext context: NSManagedObjectContext,
								completion: @escaping () -> Void)
}

final class Migrator: DatabaseMigrator
{
	static var isMigrationRequired: Bool
	{
		return words.count > 0
	}
	
	static func migrateDatabase(inContext context: NSManagedObjectContext,
								completion: @escaping () -> Void)
	{
		DispatchQueue.global(qos: .default).async
			{
				context.makeChanges
					{ [unowned context] in
						for oldWordEntry in words.allWords()
						{
							let newWord: DictionaryQuery = context.insertObject()
							newWord.word = oldWordEntry.trimmingCharacters(in: .whitespacesAndNewlines)
						}
						removeOldDatabaseEntries()
						DispatchQueue.main.async
							{
								completion()
						}
				}
		}
	}
	
	private static func removeOldDatabaseEntries()
	{
		words.clear()
	}
}
