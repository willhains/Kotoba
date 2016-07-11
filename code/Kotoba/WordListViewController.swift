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
	}
}

// MARK:- Add "Edit" button
extension WordListViewController
{
	func prepareEditButton()
	{
		self.navigationItem.rightBarButtonItem = self.editButtonItem()
	}
}

// MARK:- Tap a word in the list to see its description
extension WordListViewController
{
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
	{
		// Search the dictionary
		let word = words[indexPath.row]
		showDefinitionForWord(word)
		
		// Reset the table view
		self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
}

// MARK:- Swipe left to delete words
extension WordListViewController
{
	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
	{
		return true
	}
	
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
	{
		if editingStyle == .Delete
		{
			words.deleteWord(atIndex: indexPath.row)
			self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
		}
	}
}

// MARK:- Data source
extension WordListViewController
{
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int
	{
		// Just a single, simple list
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return words.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	{
		let cell = tableView.dequeueReusableCellWithIdentifier("Word", forIndexPath: indexPath)
		cell.textLabel?.text = words[indexPath.row].text
		return cell
	}
}
