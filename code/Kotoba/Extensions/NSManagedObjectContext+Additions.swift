//
//  NSManagedObjectContext+Additions.swift
//  Kotoba
//
//  Created by Gabor Halasz on 18/07/2018.
//  Copyright © 2018 Will Hains. All rights reserved.
//

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
	// GH: I don't personally use that convention and have not yet seen it beeing used by
	// other iOS developers either. I think `private` keywoard usage is enough for differentiation.
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
	func insertObject<EntityType: NSManagedObject>() -> EntityType where EntityType: Managed
	{
		guard let object = NSEntityDescription.insertNewObject(forEntityName: EntityType.entityName, into: self) as? EntityType
			else { fatalError("Wrong object type") }
		return object
	}
}
