//
//  ContextMerger.swift
//  Kotoba
//
//  Created by Gabor Halasz on 20/07/2018.
//  Copyright © 2018 Will Hains. All rights reserved.
//

import Foundation
import CoreData

final class ContextMerger {
  let contextProvider: ContextProvider
  
  init(contextProvider: ContextProvider) {
    self.contextProvider = contextProvider
    observeSaveNotification()
  }
  
  private func observeSaveNotification() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(handle(notification:)),
                                           name: .NSManagedObjectContextDidSave,
                                           object: nil)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: .NSManagedObjectContextDidSave, object: nil)
  }
  
  @objc private func handle(notification: Notification) {
    guard let backgroundContext = notification.object  as? NSManagedObjectContext else { return }
    if !contextProvider.mainContext.isEqual(backgroundContext) {
      contextProvider.mainContext.mergeChanges(fromContextDidSave: notification)
    }
  }
}
