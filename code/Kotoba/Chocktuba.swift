//
// Created by Will Hains on 2020-06-21.
// Copyright (c) 2020 Will Hains. All rights reserved.
//

import UIKit

// MARK:- UserDefaults

private let _CHOCKTUBA_DUH = "FIXTHISAPP"

extension UserDefaults
{
	var CHOCKTUBA_DUH: Bool
	{
		get { bool(forKey: _CHOCKTUBA_DUH) }
		set { set(newValue, forKey: _CHOCKTUBA_DUH) }
	}
}

// MARK:- AddWordViewController

class ChocktubaAddWordViewController: AddWordViewController
{
	override func viewDidLoad()
	{
		super.viewDidLoad()

		if UserDefaults.standard.CHOCKTUBA_DUH
		{
			self.textField.autocapitalizationType = .allCharacters
		}
	}

	override func textFieldShouldReturn(_ textField: UITextField) -> Bool
	{
		guard let text = textField.text else { return true }
		guard text == "CHOCKTUBA" else { return super.textFieldShouldReturn(textField) }

		UserDefaults.standard.CHOCKTUBA_DUH.toggle()
		if UserDefaults.standard.CHOCKTUBA_DUH
		{
			UserDefaults.standard.set(["chock"], forKey: "AppleLanguages")
		}
		else
		{
			UserDefaults.standard.removeObject(forKey: "AppleLanguages")
		}
		UserDefaults.standard.synchronize()

		var title: String
		var message: String
		if UserDefaults.standard.CHOCKTUBA_DUH
		{
			title = "CHOCKTUBA ON"
			message = "YOU JUST MADE THIS APP A BILLION TIMES BETTER CONGRATS"
		}
		else
		{
			title = "CHOCKTUBA OFF"
			message = "WHAT THE HELL ARE YOU THINKING"
		}

		let alert = UIAlertController(
			title: title,
			message: message,
			preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "CTL ALT DEL TO RESTART", style: .default)
		{
			action in
			exit(0)
		})
		self.present(alert, animated: true, completion: nil)
		return true
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let cell = super.tableView(tableView, cellForRowAt: indexPath)
		if UserDefaults.standard.CHOCKTUBA_DUH
		{
			cell.textLabel?.text = cell.textLabel?.text!.uppercased()
		}
		return cell
	}
}

// MARK:- WordListViewController

class ChocktubaWordListViewController: WordListViewController
{
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let cell = super.tableView(tableView, cellForRowAt: indexPath)
		if UserDefaults.standard.CHOCKTUBA_DUH
		{
			cell.textLabel?.text = cell.textLabel?.text!.uppercased()
		}
		return cell
	}
}

// MARK:- SettingsViewController

class ChocktubaSettingsViewController: SettingsViewController
{
	override func viewDidLoad()
	{
		CHOCKTUBA.isHidden = !UserDefaults.standard.CHOCKTUBA_DUH
		super.viewDidLoad()
	}
}
