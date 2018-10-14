//
//  NSManagedObjectContext+Additions.swift
//  Kotoba
//
//  Created by Gabor Halasz on 18/07/2018.
//  Copyright © 2018 Will Hains. All rights reserved.
//

import Foundation // WH: Redundant import?
import CoreData

extension NSManagedObjectContext
{
	func makeChanges(_ changes: @escaping () -> Void)
	{
		perform
		{
			[weak self] in
			changes()
			_ = self?.saveOrRollBack()
		}
	}
	
	// WH: I always prefix private members with underscore. Is that not a thing in Swift?
	private func saveOrRollBack() -> Bool
	{
		do
		{
			try save()
			return true
		}
		catch
		{
			rollback()
			return false
		}
	}
}

extension NSManagedObjectContext
{
	// WH: Let's rename `A` to something meaningful, like `EntityType` (if that's not already used for something).
	func insertObject<A: NSManagedObject>() -> A where A: Managed
	{
		guard let object = NSEntityDescription.insertNewObject(forEntityName: A.entityName, into: self) as? A
			else { fatalError("Wrong object type") }
		return object
	}
}
