//
//  Managed.swift
//  Kotoba
//
//  Created by Gabor Halasz on 18/07/2018.
//  Copyright © 2018 Will Hains. All rights reserved.
//

import Foundation // WH: Redundant import?
import CoreData

protocol Managed
{
	static var entityName: String { get }
	static var defaultSortDescriptors: [NSSortDescriptor] { get }
	static var sortedFetchRequest: NSFetchRequest<NSFetchRequestResult> { get }
}

extension Managed
{
	static var sortedFetchRequest: NSFetchRequest<NSFetchRequestResult>
	{
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
		request.sortDescriptors = defaultSortDescriptors
		return request
	}
}
