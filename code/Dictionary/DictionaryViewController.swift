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
	@IBOutlet weak var dictionaryContainer: UIView!
	
	override func viewDidAppear(animated: Bool)
	{
		// Show the keyboard on launch, so you can start typing right away
		self.searchBar.becomeFirstResponder()
	}
	
	func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
	{
		// Delay slightly to make typing smoother
		Timer("type delay", 1.0)
		{
			// Check if dictionary contains typed word
			let searchText = searchBar.text
			if UIReferenceLibraryViewController.dictionaryHasDefinitionForTerm(searchText)
			{
				// Create the dictionary view controller
				let referenceViewController = UIReferenceLibraryViewController(term: searchText)
				
				// Display the dictionary view inside the container view
				self.addChildViewController(referenceViewController)
				referenceViewController.view.frame = self.dictionaryContainer.frame
				self.view.addSubview(referenceViewController.view)
				referenceViewController.didMoveToParentViewController(self)
			}
		}
	}
	
	func searchBarSearchButtonClicked(searchBar: UISearchBar)
	{
		// Hide keyboard
		searchBar.resignFirstResponder()
	}
}
