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

protocol WordUI {
  var wordString: String { get }
  var favorite: Bool { get set }
  var entryDate: Date { get set }

  func findOrCreateNew(word: String, inContext context: NSManagedObjectContext) -> WordUI
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

extension DictionaryQuery: Managed {
  static var entityName: String { return "DictionaryQuery" }
  static var defaultSortDescriptors: [NSSortDescriptor] {
    let sortDescriptor = NSSortDescriptor(key: DictionaryQueryAttribute.date.rawValue, ascending: true)
    return [sortDescriptor]
  }
}

extension DictionaryQuery: WordUI {
  var wordString: String { return  self.word }
  var favorite: Bool {
    get { return isFavorite.boolValue }
    set { isFavorite = NSNumber(booleanLiteral: newValue) }
  }
  var entryDate: Date {
    get { return date }
    set { date = newValue }
  }

  func findOrCreateNew(word: String, inContext context: NSManagedObjectContext) -> WordUI {
    let predicate = NSPredicate(format: "%K == %@", DictionaryQueryAttribute.word.rawValue, word)
    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: DictionaryQuery.entityName)
    fetch.predicate = predicate
    
    guard let dictionaryQuery = try? context.fetch(fetch).first as? DictionaryQuery
      else {
        let newDictionaryQuery: DictionaryQuery = context.insertObject()
        newDictionaryQuery.word = word
        return newDictionaryQuery
    }
    
    return dictionaryQuery!
  }
}
