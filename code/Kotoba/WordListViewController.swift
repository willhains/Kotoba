//
//  WordListViewController
//  Kotoba
//
//  Created by Will Hains on 2014-11-24.
//  Copyright (c) 2014 Will Hains. All rights reserved.
//

import UIKit

class WordListViewController: UITableViewController
{
	override func viewDidLoad()
	{
		super.viewDidLoad()
		prepareEditButton()
		prepareSelfSizingTableCells()
	}
	
	deinit
	{
		NotificationCenter.default.removeObserver(self)
	}
}

// MARK:- Add "Edit" button
extension WordListViewController
{
	func prepareEditButton()
	{
		self.navigationItem.rightBarButtonItem = self.editButtonItem
	}
}

// MARK:- Dynamic Type
extension WordListViewController
{
	func prepareSelfSizingTableCells()
	{
		// Self-sizing table rows
		tableView.estimatedRowHeight = 44
		tableView.rowHeight = UITableView.automaticDimension
		
		// Update view when dynamic type changes
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(WordListViewController.dynamicTypeSizeDidChange),
			name: UIContentSizeCategory.didChangeNotification,
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
		let word = words[indexPath.row]
		let _ = showDefinition(forWord: word)
		
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
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
	{
		if editingStyle == .delete
		{
			words.delete(wordAt: indexPath.row)
			self.tableView.deleteRows(at: [indexPath], with: .automatic)
		}
	}
}

// MARK:- Data source
extension WordListViewController
{
	override func numberOfSections(in tableView: UITableView) -> Int
	{
		// Just a single, simple list
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return words.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath) as! WordListCell
		cell.word = words[indexPath.row]
		return cell
	}
}

class WordListCell: UITableViewCell
{
	/// The word displayed by the table cell.
	var word: Word?
	{
		get { return textLabel?.text.flatMap(Word.init) }
		set { textLabel?.text = newValue?.text }
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		super.init(coder: aDecoder)
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
	{
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		// Prepare text label for dynamic type
		textLabel?.font = .preferredFont(forTextStyle: UIFont.TextStyle.body)
	}
}
