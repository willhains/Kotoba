//
//  KotobaViewController
//  Kotoba
//
//  Created by Will Hains on 2014-11-24.
//  Copyright (c) 2014 Will Hains. All rights reserved.
//

import UIKit

class KotobaViewController: UIViewController
{
	let words = WordList()
	
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var bottomConstraint: NSLayoutConstraint!
	
	deinit
	{
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
}

// MARK:- Keyboard avoiding
extension KotobaViewController
{
	override func viewDidLoad()
	{
		NSNotificationCenter.defaultCenter().addObserver(
			self,
			selector: #selector(KotobaViewController.keyboardWillShow(_:)),
			name:UIKeyboardWillShowNotification,
			object: nil);
		NSNotificationCenter.defaultCenter().addObserver(
			self,
			selector: #selector(KotobaViewController.keyboardWillHide(_:)),
			name:UIKeyboardWillHideNotification,
			object: nil);
		
		// Show the keyboard on launch, so you can start typing right away
		self.searchBar.becomeFirstResponder()
	}
	
	func keyboardWillShow(sender: NSNotification)
	{
		let info = sender.userInfo!
		let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height
		bottomConstraint.constant = keyboardSize - bottomLayoutGuide.length
		
		let duration: NSTimeInterval = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
		UIView.animateWithDuration(duration) { self.view.layoutIfNeeded() }
	}
	
	func keyboardWillHide(sender: NSNotification)
	{
		let info = sender.userInfo!
		bottomConstraint.constant = 0
		
		let duration: NSTimeInterval = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
		UIView.animateWithDuration(duration) { self.view.layoutIfNeeded() }
	}
}

// MARK:- Table View Delegate
extension KotobaViewController: UITableViewDelegate
{
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
	{
		// Search the Kotoba
		let searchText = words[indexPath.row].text
		let kotobaVC = UIReferenceLibraryViewController(term: searchText)
		presentViewController(kotobaVC, animated: true)
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
extension KotobaViewController: UITableViewDataSource
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
extension KotobaViewController: UISearchBarDelegate
{
	func searchBarSearchButtonClicked(searchBar: UISearchBar)
	{
		// Search the Kotoba
		if let searchText = searchBar.text
		{
			let kotobaVC = UIReferenceLibraryViewController(term: searchText)
			presentViewController(kotobaVC, animated: true)
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
extension KotobaViewController
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
