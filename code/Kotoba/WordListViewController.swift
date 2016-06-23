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
	let words = WordList()
}

// MARK:- Table View Delegate
extension WordListViewController
{
	override func viewDidLoad()
	{
		self.navigationItem.rightBarButtonItem = self.editButtonItem()
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
	{
		// Search the dictionary
		let word = words[indexPath.row]
		showDefinitionForWord(word)
		
		// Reset the table view
		self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
	
	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
	{
		return true
	}
	
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
	{
		if editingStyle == .Delete
		{
			self.words.deleteWord(atIndex: indexPath.row)
			self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
		}
	}
}

// MARK:- Data source
extension WordListViewController
{
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int
	{
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
