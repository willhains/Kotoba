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

final class SettingsViewController: UIViewController, UIDocumentPickerDelegate, UINavigationControllerDelegate
{
	@IBOutlet weak var iCloudSyncSwitch: UISwitch!
	@IBOutlet weak var clipboardImportButton: UIView!
	@IBOutlet weak var clipboardWordCount: UILabel!
	@IBOutlet weak var fileImportButton: UIView!
	@IBOutlet var clipboardButtonTap: UITapGestureRecognizer!
	@IBOutlet var fileButtonTap: UITapGestureRecognizer!
	
	override func viewDidLoad()
	{
		iCloudSyncSwitch.addTarget(self, action: #selector(_switchWordListStore), for: .valueChanged)
		
		let borderColour = UIColor(named: "appTint")!.cgColor
		clipboardImportButton.layer.borderColor = borderColour
		fileImportButton.layer.borderColor = borderColour
	}
	
	override func viewWillAppear(_ animated: Bool)
	{
		_refreshViews()
	}
	
	@IBAction func importFromClipboard(_ sender: Any)
	{
		debugLog("Importing from clipboard")
		if let text = UIPasteboard.general.string { _import(newlineDelimitedWords: text) }
	}
	
	@IBAction func importFromFile(_ sender: Any)
	{
		debugLog("Importing from file")
		_importFromFile()
	}
	
	private func _refreshViews()
	{
		iCloudSyncSwitch.setOn(wordListStore == .iCloud, animated: true)
		clipboardWordCount.text = "\(UIPasteboard.general.lines.count) words"
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
		text.split(separator: "\n")
			.map { $0.trimmingCharacters(in: .whitespaces) }
			.filter { !$0.isEmpty }
			.forEach { words.add(word: Word(text: $0)) }
		_refreshViews()
		let countAfter = words.count
		let addedWords = countAfter - countBefore
		if addedWords < 0 { fatalError("Negative added words") }
		let alert = UIAlertController(
			title: "Import Successful",
			message: "\(addedWords) \(addedWords == 1 ? "word" : "words") added.",
			preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
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
				title: "Import Failed",
				message: error.localizedDescription,
				preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController)
	{
		debugLog("import was cancelled")
		dismiss(animated: true, completion: nil)
	}
}
