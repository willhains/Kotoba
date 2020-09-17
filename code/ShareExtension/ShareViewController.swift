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
	@IBOutlet var wordLabel: UILabel!
	
	var contentText: String = ""
	
	required init?(coder: NSCoder)
	{
		super.init(coder: coder)
	}
	
	override func viewDidLoad()
	{
		debugLog("ShareExtension: viewDidLoad()")
		super.viewDidLoad()
		
		let extensionItem = extensionContext?.inputItems.first as! NSExtensionItem
		let itemProvider = extensionItem.attachments?.first!
		let propertyList = String(kUTTypeText)
		if itemProvider?.hasItemConformingToTypeIdentifier(propertyList) ?? false
		{
			itemProvider?.loadItem(forTypeIdentifier: propertyList, options: nil, completionHandler:
			{
				(item, error) -> Void in
				guard let text = item as? String else
				{
					debugLog("ShareExtension: no word text found when loading from itemProvider")
					return
				}
				debugLog("ShareExtension: got word text = \(text); now invoking main queue...")
				DispatchQueue.main.async
				{
					debugLog("ShareExtension: [main queue] setting word content")
					self.contentText = text
					self.wordLabel.text = text
				}
			})
		}
		else
		{
			debugLog("ShareExtension: no word text found in extensionItem")
		}
	}
	
	override func viewDidAppear(_ animated: Bool)
	{
		debugLog("ShareExtension: viewDidAppear()")
		debugLog("ShareExtension: iCloud=\(NSUbiquitousKeyValueStore.iCloudEnabledInSettings)")
		debugLog("ShareExtension: self.contentText=\(self.contentText)")
		debugLog("ShareExtension: self.wordLabel.text=\(self.wordLabel.text ?? "NONE")")
		debugLog("ShareExtension: wordListStore.latestWord=\(wordListStore.data.latestWord?.text ?? "NONE")")
		initiateSearch(forWord: Word(text: contentText))
	}
	
	func completeShare()
	{
		debugLog("ShareExtension: completeShare()")
		extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
	}
	
	@IBAction func didTapCancel(_ sender: UIBarButtonItem)
	{
		debugLog("ShareExtension: didTapCancel()")
		completeShare()
	}
}

// MARK:- Kotoba and Dictionary Integration
extension ShareViewController
{
	func initiateSearch(forWord word: Word)
	{
		debugLog("ShareExtension: initiateSearch(forWord: \(word))")
		let hasDefinition = UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: word.text)
		debugLog("hasDefinition = \(hasDefinition)")
		if hasDefinition
		{
			debugLog("ShareExtension: adding word '\(word)' to store")

			// Update local store and iCloud store (if enabled)
			var localData = WordListStore.local.data
			localData.add(word: word)
			var maybeCloudData = wordListStore.data
			maybeCloudData.add(word: word)
		}
		let dictionaryViewController = DictionaryViewController(term: word.text)
		self.present(dictionaryViewController, animated: true)
		{
			dictionaryViewController.onDismiss = self.completeShare
		}
	}
}
