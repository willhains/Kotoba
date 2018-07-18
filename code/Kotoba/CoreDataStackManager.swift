//
//  CoreDataStackManager.swift
//  Kotoba
//
//  Created by Gabor Halasz on 18/07/2018.
//  Copyright © 2018 Will Hains. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataStackManager {
  private var container: NSPersistentContainer!

  init(modelName: String, completion: @escaping (Bool) -> Void) {
    container = NSPersistentContainer(name: modelName)
    container.loadPersistentStores { description, error in
      let success = error == nil
      completion(success)
     }
  }
}

extension CoreDataStackManager: ContextProvider {
  var mainContext: NSManagedObjectContext { return container.viewContext }
  var backgroundContext: NSManagedObjectContext { return container.newBackgroundContext() }
}
