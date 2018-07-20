//
//  WordListViewController
//  Kotoba
//
//  Created by Will Hains on 2014-11-24.
//  Copyright (c) 2014 Will Hains. All rights reserved.
//

import UIKit
import CoreData

class WordListViewController: UITableViewController
{
  private let dataSource: TableViewDataSource
  private let cellIdentifier = "WordCell"
  
  init(dataSource: TableViewDataSource)
  {
    self.dataSource = dataSource
    super.init(style: .plain)
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    fatalError("init(coder:) has not been implemented")
  }
  
	override func viewDidLoad()
	{
		super.viewDidLoad()
    prepareTableView()
		prepareEditButton()
		prepareSelfSizingTableCells()
	}
	
	deinit
	{
		NotificationCenter.default.removeObserver(self)
	}
}

extension WordListViewController
{
  private func prepareTableView()
  {
    tableView.register(WordListTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    tableView.dataSource = dataSource
    tableView.reloadData()
  }
}

// MARK:- Add "Edit" button
extension WordListViewController
{
	private func prepareEditButton()
	{
		self.navigationItem.rightBarButtonItem = self.editButtonItem
	}
	
	func prepareTextLabelForDynamicType(label: UILabel?)
	{
		label?.font = .preferredFont(forTextStyle: .body)
	}
}

// MARK:- Dynamic Type
extension WordListViewController
{
	private func prepareSelfSizingTableCells()
	{
		// Self-sizing table rows
		tableView.estimatedRowHeight = 44
		tableView.rowHeight = UITableViewAutomaticDimension
		
		// Update view when dynamic type changes
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(WordListViewController.dynamicTypeSizeDidChange),
			name: .UIContentSizeCategoryDidChange,
			object: nil)
	}
	
	@objc private func dynamicTypeSizeDidChange()
	{
		self.tableView.reloadData()
	}
}

// MARK:- data source delegate
extension WordListViewController: TableViewDataSourceDelegate
{
  func cellIdentifier(for indexPath: IndexPath) -> String
  {
    return cellIdentifier
  }
  
  func configure(cell: UITableViewCell, with object: NSFetchRequestResult, at indexPath: IndexPath)
  {
    guard let word = object as? WordUI else { return }
    cell.textLabel?.text = word.wordString
    prepareTextLabelForDynamicType(label: cell.textLabel)
  }
  
  func currentTableView() -> UITableView? {
    return tableView
  }
}

// MARK:- Tap a word in the list to see its description
extension WordListViewController
{
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		// Search the dictionary
    guard let word = dataSource.object(at: indexPath) as? WordUI else { self.tableView.deselect(); return }
    let _ = showDefinition(forWord: word.wordString)
		
		// Reset the table view
		self.tableView.deselect()
	}
}
