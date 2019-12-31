//
//  SettingsViewController.swift
//  Kotoba
//
//  Created by Will Hains on 2019-11-27.
//  Copyright © 2019 Will Hains. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import LinkPresentation

final class SettingsViewController: UIViewController, UIDocumentPickerDelegate, UINavigationControllerDelegate
{
	@IBOutlet weak var iCloudSyncSwitch: UISwitch!
	@IBOutlet weak var clipboardImportButton: RoundedView!
	@IBOutlet weak var clipboardWordCount: UILabel!
	@IBOutlet weak var fileImportButton: RoundedView!
	@IBOutlet var clipboardButtonTap: UILongPressGestureRecognizer!
	@IBOutlet var fileButtonTap: UILongPressGestureRecognizer!
	@IBOutlet weak var CHOCKTUBA: UIView!
	@IBOutlet weak var enableICloudButton: UIButton!
	
	override func viewDidLoad()
	{
		iCloudSyncSwitch.addTarget(self, action: #selector(_switchWordListStore), for: .valueChanged)
		
		CHOCKTUBA.isHidden = !UserDefaults.standard.CHOCKTUBA_DUH
	}
	
	override func viewWillAppear(_ animated: Bool)
	{
		_refreshViews()
	}
	
	@IBAction func closeSettings(_ sender: Any)
	{
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func importFromClipboard(_ gesture: UITapGestureRecognizer)
	{
		guard UIPasteboard.general.lines.count > 0 else { return }
		if gesture.state == .began
		{
			clipboardImportButton.backgroundColor = .systemFill
		}
		else if gesture.state == .ended
		{
			clipboardImportButton.backgroundColor = .tertiarySystemFill
			debugLog("Importing from clipboard")
			if let text = UIPasteboard.general.string
			{
				_import(newlineDelimitedWords: text)
			}
		}
	}
	
	@IBAction func importFromFile(_ gesture: UITapGestureRecognizer)
	{
		if gesture.state == .began
		{
			fileImportButton.backgroundColor = .systemFill
		}
		else if gesture.state == .ended
		{
			fileImportButton.backgroundColor = .tertiarySystemFill
			debugLog("Importing from file")
			_importFromFile()
		}
	}
	
	@IBAction func openGithub(_ sender: Any)
	{
		if let url = URL(string: "https://github.com/willhains/Kotoba") {
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		}
	}
	
	@IBAction func openICloudSettings(_ sender: Any)
	{
		if let url = URL(string: "App-prefs:root=CASTLE")
		{
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		}
	}
	
	private func _pluralizedWordCount(_ count: Int) -> String
	{
		let format = NSLocalizedString("WordCount", comment: "Count of words available")
		let wordCount = String.localizedStringWithFormat(format, count)
		return wordCount
	}
	
	private func _refreshViews()
	{
		// iCloud settings
		iCloudSyncSwitch.setOn(wordListStore == .iCloud, animated: true)
		enableICloudButton.isHidden = wordListStore != .iCloud || NSUbiquitousKeyValueStore.default.iCloudEnabledInSettings
		
		// Import settings
		let count = UIPasteboard.general.lines.count
		clipboardWordCount.text = _pluralizedWordCount(count)
		self.clipboardImportButton.enabled = count > 0
	}
	
	@objc private func _switchWordListStore()
	{
		let store: WordListStore = iCloudSyncSwitch.isOn ? .iCloud : .local
		debugLog("Switching word list store to \(store)")
		wordListStore = store
		_refreshViews()
	}
	
	private func _import(newlineDelimitedWords text: String)
	{
		var words = wordListStore.data
		let countBefore = words.count
		let importWords = text.split(separator: "\n")
			.map { $0.trimmingCharacters(in: .whitespaces) }
			.filter { !$0.isEmpty }
		importWords.forEach { words.add(word: Word(text: $0)) }
		_refreshViews()
		let countAfter = words.count
		let addedWords = countAfter - countBefore
		let duplicateWords = importWords.count - addedWords
		if addedWords < 0 { fatalError("Negative added words") }
		let message = String(format: NSLocalizedString("IMPORT_SUCCESS_MESSAGE", comment: "Message for successful import"), _pluralizedWordCount(importWords.count), _pluralizedWordCount(duplicateWords), _pluralizedWordCount(addedWords))
		let alert = UIAlertController(
			title: NSLocalizedString("IMPORT_SUCCESS_TITLE", comment: "Title for successful import"),
			message: message,
			preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
	
	private func _importFromFile()
	{
		let types: [String] = [kUTTypeText as String]
		let documentPicker = UIDocumentPickerViewController(documentTypes: types, in: .import)
		documentPicker.delegate = self
		documentPicker.modalPresentationStyle = .formSheet
		self.present(documentPicker, animated: true, completion: nil)
	}
	
	public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL])
	{
		guard let fileURL = urls.first else { return }
		debugLog("importing: \(fileURL)")
		do
		{
			let text = try String(contentsOf: fileURL, encoding: .utf8)
			_import(newlineDelimitedWords: text)
		}
		catch
		{
			debugLog("Import failed: \(error)")
			let alert = UIAlertController(
				title: NSLocalizedString("IMPORT_FAIL_TITLE", comment: "Title for failed import"),
				message: error.localizedDescription,
				preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
			self.present(alert, animated: true, completion: nil)
		}
	}
}

@IBDesignable class RoundedView: UIView
{
	var enabled: Bool = true
	{
		willSet(newValue)
		{
			layer.opacity = newValue ? 1.0 : 0.3
		}
	}
	
	@IBInspectable var cornerRadius: CGFloat
	{
		get { layer.cornerRadius }
		set
		{
			layer.cornerRadius = newValue
			layer.masksToBounds = newValue > 0
		}
	}
	
	@IBInspectable var borderWidth: CGFloat
	{
		get { layer.borderWidth }
		set
		{
			layer.borderWidth = newValue
		}
	}
	
	@IBInspectable var borderColor: UIColor?
	{
		get { layer.borderColor.map { UIColor.init(cgColor: $0) } }
		set
		{
			layer.borderColor = newValue?.cgColor
		}
	}
}

private let _INSTALLATION_INSTRUCTIONS = """
# How to Install Kotoba #

**Note:** An Apple Developer account is required.

1. Download the Kotoba
"""

// MARK:- Export Word List
extension SettingsViewController: UIActivityItemSource
{
	@IBAction func shareInstallationInstructions(_ sender: Any)
	{
		let items = [self]
		let shareSheet = UIActivityViewController(activityItems: items, applicationActivities: nil)
		present(shareSheet, animated: true)
	}
	
	func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any
	{
		return "Kotoba Installation Instructions"
	}
	
	func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any?
	{
		return _INSTALLATION_INSTRUCTIONS
	}
	
	func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String
	{
		return "Kotoba Installation Instructions"
	}

	func activityViewControllerLinkMetadata(_: UIActivityViewController) -> LPLinkMetadata?
	{
		let metadata = LPLinkMetadata()
		metadata.title = NSLocalizedString("INSTALLATION_INSTRUCTIONS_TITLE", comment: "Kotoba Installation Instructions")
		return metadata
	}
}
