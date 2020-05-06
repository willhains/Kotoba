//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Will Hains on 2020-05-05.
//  Copyright © 2020 Will Hains. All rights reserved.
//

import UIKit
import Social
import CoreServices

class ShareViewController: UIViewController
{
	var contentText: String = ""

	required init?(coder: NSCoder)
	{
		super.init(coder: coder)
	}
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
        let extensionItem = extensionContext?.inputItems.first as! NSExtensionItem
		let itemProvider = extensionItem.attachments?.first!
        let propertyList = String(kUTTypeText)
		if itemProvider?.hasItemConformingToTypeIdentifier(propertyList) ?? false
		{
			itemProvider?.loadItem(forTypeIdentifier: propertyList, options: nil, completionHandler:
			{
				(item, error) -> Void in
				guard let text = item as? String else { return }
				self.contentText = text
            })
        }
		else
		{
            print("error")
        }
	}
}

// MARK:- Kotoba and Dictionary Integration
extension ShareViewController
{
	func initiateSearch(forWord word: Word)
	{
		let hasDefinition = UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: word.text)
		debugLog("hasDefinition = \(hasDefinition)")
		let dictionaryViewController = DictionaryViewController(term: word.text)
		self.present(dictionaryViewController, animated: true)
		{
			dictionaryViewController.onDismiss =
			{
				if hasDefinition
				{
					var words = wordListStore.data
					words.add(word: word)
					
					self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
				}
			}
		}
	}
}

// MARK:- Table View delegate/datasource
extension ShareViewController: UITableViewDelegate, UITableViewDataSource
{
	var words: [Word]
	{
		return contentText
			.trimmingCharacters(in: .whitespacesAndNewlines)
			.asWords()
			.removingTrivialEnglishWords()
			.map(Word.init)
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return words.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
		let text = words[indexPath.row].text
		cell.textLabel?.text = UserDefaults.standard.CHOCKTUBA_DUH ? text.uppercased() : text
		cell.textLabel?.font = .preferredFont(forTextStyle: UIFont.TextStyle.body) // TODO: Move to extension of UILabel
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		guard indexPath.row >= 0 else { return }
		let word = words[indexPath.row]
		initiateSearch(forWord: word)
		tableView.selectRow(at: nil, animated: true, scrollPosition: .none)
	}
}
