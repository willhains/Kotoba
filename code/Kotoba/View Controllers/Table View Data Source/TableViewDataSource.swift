//
//  TableViewDataSource.swift
//  Kotoba
//
//  Created by Gabor Halasz on 19/07/2018.
//  Copyright © 2018 Will Hains. All rights reserved.
//

import UIKit
import CoreData

protocol TableViewDataSourceDelegate: class
{
  func cellIdentifier(for indexPath: IndexPath) -> String
  func configure(cell: UITableViewCell,
                 with object: NSFetchRequestResult,
                 at indexPath: IndexPath)
  func currentTableView() -> UITableView?
}

protocol TableViewDataSource: UITableViewDataSource
{
  var delegate: TableViewDataSourceDelegate? { get set }
  var allowRowEdit: Bool { get set }
  init(request: NSFetchRequest<NSFetchRequestResult>,
       contextProvider: ContextProvider)
  func object(at indexPath: IndexPath) -> NSFetchRequestResult
}
