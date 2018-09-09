//
//  DictionaryQuery.swift
//  Kotoba
//
//  Created by Gabor Halasz on 18/07/2018.
//  Copyright © 2018 Will Hains. All rights reserved.
//

import Foundation
import CoreData

enum DictionaryQueryAttribute: String
{
  case date = "date"
  case isFavorite = "isFavorite"
  case word = "word"
}

protocol WordUI
{
  var wordString: String { get }
  var favorite: Bool { get set }
  var entryDate: Date { get set }
  var isNewEntry: Bool { get }

  static func findOrAdd(word: String, inContext context: NSManagedObjectContext) -> WordUI
}

final class DictionaryQuery: NSManagedObject
{
  @NSManaged var date: Date!
  @NSManaged var isFavorite: NSNumber!
  @NSManaged var word: String!

  override func awakeFromInsert()
  {
    super.awakeFromInsert()
    date = Date()
    isFavorite = NSNumber(booleanLiteral: false)
    word = String()
  }
}

extension DictionaryQuery: Managed
{
  static var entityName: String
  {
    return String(describing: DictionaryQuery.self)
    
  }
  static var defaultSortDescriptors: [NSSortDescriptor]
  {
    let alphabeticSortDescriptor = NSSortDescriptor(key: DictionaryQueryAttribute.word.rawValue, ascending: true)
    let dateSortDescriptor = NSSortDescriptor(key: DictionaryQueryAttribute.date.rawValue, ascending: true)
    return [alphabeticSortDescriptor, dateSortDescriptor]
  }
}

extension DictionaryQuery: WordUI
{
  var wordString: String
  {
    return  self.word
  }
  var favorite: Bool
  {
    get { return isFavorite.boolValue }
    set { isFavorite = NSNumber(booleanLiteral: newValue) }
  }
  var entryDate: Date
  {
    get { return date }
    set { date = newValue }
  }
  var isNewEntry: Bool
  {
    return objectID.isTemporaryID
  }

  static func findOrAdd(word: String, inContext context: NSManagedObjectContext) -> WordUI
  {
    let predicate = NSPredicate(format: "%K == %@", DictionaryQueryAttribute.word.rawValue, word)
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: DictionaryQuery.entityName)
    request.sortDescriptors = DictionaryQuery.defaultSortDescriptors
    request.predicate = predicate
    
    guard let dictionaryQuery = try! context.fetch(request).first as? DictionaryQuery
      else
    {
      let dictionaryQuery: DictionaryQuery = context.insertObject()
      dictionaryQuery.word = word
      return dictionaryQuery
    }
    
    return dictionaryQuery
  }
}
