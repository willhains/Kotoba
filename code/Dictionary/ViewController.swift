//
//  DictionaryViewController
//  Dictionary
//
//  Created by Will Hains on 2014-11-24.
//  Copyright (c) 2014 Will Hains. All rights reserved.
//

import UIKit

class DictionaryViewController: UIViewController
{
	let words = WordList()
	
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var tableView: UITableView!
}

// MARK:- Table View Delegate
extension DictionaryViewController: UITableViewDelegate
{
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
	{
		// Search the dictionary
		let searchText = words[indexPath.row].text
		let dictionaryVC = UIReferenceLibraryViewController(term: searchText)
		presentViewController(dictionaryVC, animated: true)
		{
			self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
		}
	}
	
	func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
	{
		return true
	}
	
	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
	{
		if editingStyle == .Delete
		{
			self.words.deleteWord(atIndex: indexPath.row)
			self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
		}
	}
}

// MARK:- Data source
extension DictionaryViewController: UITableViewDataSource
{
	func numberOfSectionsInTableView(tableView: UITableView) -> Int
	{
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return words.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	{
		let cell = tableView.dequeueReusableCellWithIdentifier("Word", forIndexPath: indexPath)
		cell.textLabel?.text = words[indexPath.row].text
		return cell
	}
}

// MARK:- Search Bar delegate
extension DictionaryViewController: UISearchBarDelegate
{
	func searchBarSearchButtonClicked(searchBar: UISearchBar)
	{
		// Search the dictionary
		if let searchText = searchBar.text
		{
			let dictionaryVC = UIReferenceLibraryViewController(term: searchText)
			presentViewController(dictionaryVC, animated: true)
			{
				if UIReferenceLibraryViewController.dictionaryHasDefinitionForTerm(searchText)
				{
					// Add word to list of words
					self.words.addWord(Word(text: searchText))
					
					// Update the table view
					self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Automatic)
					
					// Clear the search bar
					self.searchBar.text = nil
				}
			}
		}
	}
}

// MARK:- Giant search bar
extension DictionaryViewController
{
	override func viewDidAppear(animated: Bool)
	{
		// Increase size of font and height of search bar
		forEachSubview(ofView: self.searchBar, thatIsA: UITextField.self)
		{
			textField in
			textField.font = .systemFontOfSize(24)
			textField.bounds.size.height = 88
			textField.autocapitalizationType = .None
		}
		
		// Show the keyboard on launch, so you can start typing right away
		self.searchBar.becomeFirstResponder()
	}
	
	// Rummage through the subviews of the given UIView
	func forEachSubview<V: UIView>(ofView view: UIView, thatIsA type: V.Type, actUponSubview: V -> Void)
	{
		for subview in view.subviews
		{
			if let subview = subview as? V { actUponSubview(subview) }
			forEachSubview(ofView: subview, thatIsA: type, actUponSubview: actUponSubview)
		}
	}
}
