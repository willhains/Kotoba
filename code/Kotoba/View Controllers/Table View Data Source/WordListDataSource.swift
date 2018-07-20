//
//  WordListDataSource.swift
//  Kotoba
//
//  Created by Gabor Halasz on 19/07/2018.
//  Copyright © 2018 Will Hains. All rights reserved.
//

import UIKit
import CoreData

final class WordListDataSource: NSObject {
  let fetchResultsController: NSFetchedResultsController<NSFetchRequestResult>
  weak var delegate: TableViewDataSourceDelegate?
  
  init(request: NSFetchRequest<NSFetchRequestResult>,
       context: NSManagedObjectContext) {
    self.fetchResultsController = NSFetchedResultsController(fetchRequest: request,
                                                             managedObjectContext: context,
                                                             sectionNameKeyPath: nil,
                                                             cacheName: nil)
    super.init()
    try? fetchResultsController.performFetch()
  }
}

extension WordListDataSource: TableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    guard let sectionCount = fetchResultsController.sections?.count else { return 0 }
    return sectionCount
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let tableViewSection = fetchResultsController.sections?[section] else { return 0 }
    return tableViewSection.numberOfObjects
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cellID = delegate?.cellIdentifier(for: indexPath) else { fatalError("No cell type registered for given IndexPath") }
    let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
    delegate?.configure(cell: cell, with: fetchResultsController.object(at: indexPath), at: indexPath)
    return cell
  }
  
  func object(at indexPath: IndexPath) -> NSFetchRequestResult {
    return fetchResultsController.object(at: indexPath)
  }
}
