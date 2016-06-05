//
//  DictionaryViewController
//  Dictionary
//
//  Created by Will Hains on 2014-11-24.
//  Copyright (c) 2014 Will Hains. All rights reserved.
//

import UIKit

class DictionaryViewController: UIViewController, UISearchBarDelegate
{
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var tableView: UITableView!
	
	var referenceViewController: UIReferenceLibraryViewController?
	
	func searchDictionary()
	{
		// Check if dictionary contains typed word
		let searchText = self.searchBar.text
		if let searchText = searchText
		{
			if UIReferenceLibraryViewController.dictionaryHasDefinitionForTerm(searchText)
			{
				// Remove the existing dictionary view controller, if it exists
				if let refVC = self.referenceViewController
				{
					refVC.removeFromParentViewController()
					refVC.view.removeFromSuperview()
				}
				
				// Create the dictionary view controller
				let refVC = UIReferenceLibraryViewController(term: searchText)
				
				// Display the dictionary view inside the container view
				self.addChildViewController(refVC)
				refVC.view.frame = self.tableView.frame
				self.view.addSubview(refVC.view)
				refVC.didMoveToParentViewController(self)
				
				// Remember for later
				self.referenceViewController = refVC
			}
		}
	}
	
	func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
	{
		// Delay slightly to make typing smoother
		Timer("type delay", 1.0, searchDictionary).start()
	}
	
	func searchBarTextDidEndEditing(searchBar: UISearchBar)
	{
		// Search immediately
		searchDictionary()
	}
	
	func searchBarSearchButtonClicked(searchBar: UISearchBar)
	{
		// Hide keyboard
		self.searchBar.resignFirstResponder()
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
