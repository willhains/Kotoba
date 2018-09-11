//
//  ContextProvider.swift
//  Kotoba
//
//  Created by Gabor Halasz on 18/07/2018.
//  Copyright © 2018 Will Hains. All rights reserved.
//

import Foundation
import CoreData

protocol ContextProvider
{
	var mainContext: NSManagedObjectContext { get }
	var backgroundContext: NSManagedObjectContext { get }
}

protocol ContextProviderSettable
{
	var contextProvider: ContextProvider? { get set }
}
