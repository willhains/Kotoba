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
  let dataSource: TableViewDataSource
  
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

extension WordListViewController: TableViewDataSourceDelegate
{
  func cellIdentifier(for indexPath: IndexPath) -> String
  {
    return "Word"
  }
  
  func configure(cell: UITableViewCell, with object: NSFetchRequestResult, at indexPath: IndexPath)
  {
    guard let word = object as? WordUI else { return }
    print(word)
    
    cell.textLabel?.text = word.wordString
    prepareTextLabelForDynamicType(label: cell.textLabel)
  }
}

extension WordListViewController
{
  private func prepareTableView()
  {
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Word")
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
	
	@objc func dynamicTypeSizeDidChange()
	{
		self.tableView.reloadData()
	}
}

// MARK:- Tap a word in the list to see its description
extension WordListViewController
{
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		// Search the dictionary
		let word = dataSource
//    let _ = showDefinition(forWord: word)
		
		// Reset the table view
		self.tableView.deselectRow(at: indexPath, animated: true)
	}
}

// MARK:- Swipe left to delete words
extension WordListViewController
{
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
	{
		return true
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
	{
		if editingStyle == .delete
		{
			words.delete(wordAt: indexPath.row)
			self.tableView.deleteRows(at: [indexPath], with: .automatic)
		}
	}
}
