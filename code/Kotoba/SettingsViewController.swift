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

// TODO: Localise these strings.
private let _WORD_COUNT_LABEL = "%d words"
private let _MERGE_BUTTON_LABEL = "Merge from %@ into %@"
private let _REPLACE_BUTTON_LABEL = "Replace with Words from %@"
private let _LOCAL = "This Device"
private let _ICLOUD = "iCloud"

final class SettingsViewController: UITableViewController, UIDocumentPickerDelegate, UINavigationControllerDelegate
{
	@IBOutlet weak var localStoreCell: UITableViewCell!
	@IBOutlet weak var iCloudStoreCell: UITableViewCell!
	@IBOutlet weak var localWordCountLabel: UILabel!
	@IBOutlet weak var iCloudWordCountLabel: UILabel!
	@IBOutlet weak var mergeButtonLabel: UILabel!
	@IBOutlet weak var replaceButtonLabel: UILabel!
	
	override func viewWillAppear(_ animated: Bool)
	{
		_updateLabels()
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		// Word List Storage
		if indexPath.section == 0
		{
			// Local Device
			if indexPath.row == 0
			{
				_switchWordListStore(to: .local)
			}
			
			// iCloud
			else if indexPath.row == 1
			{
				_switchWordListStore(to: .iCloud)
			}
		}
		
		// Migrate Word List
		else if indexPath.section == 1
		{
			// Merge into current store from other store
			if indexPath.row == 0
			{
				debugLog("Merging word list")
				switch wordListStore
				{
					case .local: words.merge(from: dataSourceCloud)
					case .iCloud: words.merge(from: dataSourceLocal)
				}
			}
			
			// Replace current store with other store
			else if indexPath.row == 1
			{
				debugLog("Replacing word list")
				switch wordListStore
				{
					case .local: words.replace(with: dataSourceCloud)
					case .iCloud: words.replace(with: dataSourceLocal)
				}
			}
			
			_updateLabels()
		}
		
		// Import Words
		else if indexPath.section == 2
		{
			// Import words from clipboard
			if indexPath.row == 0
			{
				debugLog("Importing from clipboard")
				if let text = UIPasteboard.general.string { _import(newlineDelimitedWords: text) }
			}
			
			// Import words from a file
			else if indexPath.row == 1
			{
				debugLog("Importing from file")
				_importFromFile()
			}
		}
		
		// Un-highlight tapped row
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	private func _updateLabels()
	{
		localWordCountLabel.text = String(format: _WORD_COUNT_LABEL, dataSourceLocal.count)
		iCloudWordCountLabel.text = String(format: _WORD_COUNT_LABEL, dataSourceCloud.count)
		
		localStoreCell.accessoryType = wordListStore == .local ? .checkmark : .none
		iCloudStoreCell.accessoryType = wordListStore == .iCloud ? .checkmark : .none
		mergeButtonLabel.text = String(
			format: _MERGE_BUTTON_LABEL,
			wordListStore == .local ? _ICLOUD : _LOCAL,
			wordListStore == .local ? _LOCAL : _ICLOUD)
		replaceButtonLabel.text = String(
			format: _REPLACE_BUTTON_LABEL,
			wordListStore == .local ? _ICLOUD : _LOCAL)
	}
	
	private func _switchWordListStore(to store: WordListStore)
	{
		debugLog("Switching word list store to \(store)")
		wordListStore = store
		_updateLabels()
	}
	
	private func _import(newlineDelimitedWords text: String)
	{
		text.split(separator: "\n")
			.map { $0.trimmingCharacters(in: .whitespaces) }
			.forEach { words.add(word: Word(text: $0)) }
		_updateLabels()
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
			// TODO: Alert user of success
		}
		catch
		{
			debugLog("Import failed: \(error)")
			// TODO: Alert user of failure
		}
	}
	
	func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController)
	{
		debugLog("import was cancelled")
		dismiss(animated: true, completion: nil)
	}
}
