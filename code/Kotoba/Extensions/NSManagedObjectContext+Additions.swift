//
//  NSManagedObjectContext+Additions.swift
//  Kotoba
//
//  Created by Gabor Halasz on 18/07/2018.
//  Copyright © 2018 Will Hains. All rights reserved.
//

import Foundation
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
	func insertObject<A: NSManagedObject>() -> A where A: Managed
	{
		guard let object = NSEntityDescription.insertNewObject(forEntityName: A.entityName, into: self) as? A
			else { fatalError("Wrong object type") }
		return object
	}
}
