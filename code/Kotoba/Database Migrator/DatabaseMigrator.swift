//
//  DatabaseMigrator.swift
//  Kotoba
//
//  Created by Gabor Halasz on 18/07/2018.
//  Copyright © 2018 Will Hains. All rights reserved.
//

import Foundation

protocol DatabaseMigrator {
  static var isMigrationRequired: Bool { get }
  static func migrateDatabase(completion: @escaping (Bool) -> Void)
}

final class Migrator: DatabaseMigrator {
  static var isMigrationRequired: Bool {
    return words.count > 0
  }

  static func migrateDatabase(completion: @escaping (Bool) -> Void) {
    
  }
}