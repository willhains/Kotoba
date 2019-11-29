//
//  SettingsViewController.swift
//  Kotoba
//
//  Created by Will Hains on 2019-11-27.
//  Copyright © 2019 Will Hains. All rights reserved.
//

import Foundation
import UIKit

// TODO: Localise these strings.
private let _WORD_COUNT_LABEL = "%d words"
private let _MERGE_BUTTON_LABEL = "Merge from %@ into %@"
private let _REPLACE_BUTTON_LABEL = "Replace with Words from %@"
private let _LOCAL = "This Device"
private let _ICLOUD = "iCloud"

final class SettingsViewController: UITableViewController
{
	@IBOutlet weak var localStoreCell: UITableViewCell!
	@IBOutlet weak var iCloudStoreCell: UITableViewCell!
	@IBOutlet weak var localWordCountLabel: UILabel!
	@IBOutlet weak var iCloudWordCountLabel: UILabel!
	@IBOutlet weak var mergeButtonLabel: UILabel!
	@IBOutlet weak var replaceButtonLabel: UILabel!
	
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
			}
			
			else if indexPath.row == 1
			{
				debugLog("Replacing word list")
			}
		}
		
		// Import Words
		else if indexPath.section == 2
		{
			// Import words from clipboard
			if indexPath.row == 0
			{
				debugLog("Importing from clipboard")
			}
			
			// Import words from a file
			else if indexPath.row == 1
			{
				debugLog("Importing from file")
			}
		}
		
		// Un-highlight tapped row
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	private var _currentStore = WordListStore.local // TODO: This is temporary; delete it!
	private func _updateLabels()
	{
		// TODO: Read real word counts
		localWordCountLabel.text = String(format: _WORD_COUNT_LABEL, Int.random(in: 0...100000))
		iCloudWordCountLabel.text = String(format: _WORD_COUNT_LABEL, Int.random(in: 0...100000))
		
		// TODO: Read real state of word list store
		localStoreCell.accessoryType = _currentStore == .local ? .checkmark : .none
		iCloudStoreCell.accessoryType = _currentStore == .iCloud ? .checkmark : .none
		mergeButtonLabel.text = String(
			format: _MERGE_BUTTON_LABEL,
			_currentStore == .local ? _ICLOUD : _LOCAL,
			_currentStore == .local ? _LOCAL : _ICLOUD)
		replaceButtonLabel.text = String(
			format: _REPLACE_BUTTON_LABEL,
			_currentStore == .local ? _ICLOUD : _LOCAL)
	}
	
	private func _switchWordListStore(to store: WordListStore)
	{
		debugLog("Switching word list store to \(store)")
		
		// TODO: Set the real state of the word list store
		_currentStore = _currentStore == .local ? .iCloud : .local
		
		_updateLabels()
	}
}
