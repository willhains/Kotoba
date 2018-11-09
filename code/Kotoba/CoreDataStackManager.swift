//
//  CoreDataStackManager.swift
//  Kotoba
//
//  Created by Gabor Halasz on 18/07/2018.
//  Copyright © 2018 Will Hains. All rights reserved.
//

import CoreData

final class CoreDataStackManager
{
	private var container: NSPersistentContainer!
	private var contextMerger: ContextMerger!
	
	init(modelName: String, completion: @escaping (Bool) -> Void)
	{
		container = NSPersistentContainer(name: modelName)
		container.loadPersistentStores
		{
			[unowned self] description, error in
			let success = error == nil
			self.container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
			completion(success)
		}
		contextMerger = ContextMerger(contextProvider: self)
	}
}

extension CoreDataStackManager: ContextProvider
{
	var mainContext: NSManagedObjectContext
	{
		return container.viewContext
	}
	var backgroundContext: NSManagedObjectContext
	{
		return container.newBackgroundContext()
	}
}
