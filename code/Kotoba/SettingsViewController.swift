//
//  SettingsViewController.swift
//  Kotoba
//
//  Created by Will Hains on 2019-11-27.
//  Copyright © 2019 Will Hains. All rights reserved.
//

import Foundation
import UIKit

final class SettingsViewController: UITableViewController
{
	@IBOutlet weak var localWordCountLabel: UILabel!
	@IBOutlet weak var iCloudWordCountLabel: UILabel!
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		// Switch word list stores
		guard indexPath.section == 0 else { return }
		if indexPath.row == 0
		{
			debugLog("Switching word list store to local")
		}
		else if indexPath.row == 1
		{
			debugLog("Switching word list store to iCloud")
		}
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	@IBAction func mergeIntoSelected(_ sender: Any)
	{
		debugLog("merge")
	}
	
	@IBAction func replaceSelected(_ sender: Any)
	{
		debugLog("replace")
	}
}
