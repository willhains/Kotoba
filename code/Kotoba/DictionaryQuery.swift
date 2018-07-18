//
//  DictionaryQuery.swift
//  Kotoba
//
//  Created by Gabor Halasz on 18/07/2018.
//  Copyright © 2018 Will Hains. All rights reserved.
//

import Foundation
import CoreData

enum DictionaryQueryAttribute: String {
  case date = "date"
  case isFavorite = "isFavorite"
  case word = "word"
}

final class DictionaryQuery: NSManagedObject {
  @NSManaged var date: Date!
  @NSManaged var isFavorite: NSNumber!
  @NSManaged var word: String!

  override func awakeFromInsert() {
    super.awakeFromInsert()
    date = Date()
    isFavorite = NSNumber(booleanLiteral: false)
    word = String()
  }
}
