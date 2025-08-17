//
// Created by Will Hains on 2020-06-21.
// Copyright (c) 2020 Will Hains. All rights reserved.
//

import SwiftUI
import UIKit

// MARK:- Chocktuba

enum Chocktuba {
    private static let isEnabledStorageKey = "FIXTHISAPP"
    static let activationPhrase = "CHOCKTUBA"

    /// Chocktuba requires an app restart to change, so only read the value from User Defaults once. This
    /// avoids inconsistent state where some of the UI can briefly appear in one mode while the rest of the
    /// UI is in another.
    static private var _isEnabled: Bool?

    static var isEnabled: Bool {
        get {
            if let enabled = _isEnabled {
                return enabled
            } else {
                let enabled = UserDefaults.standard.bool(forKey: isEnabledStorageKey)
                _isEnabled = enabled
                return enabled
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: isEnabledStorageKey)
        }
    }

    static func toggle() {
        let isEnabling = !isEnabled
        isEnabled.toggle()

        // These are read and used by the system only once when the app first launches. Hence
        // the need to restart the app after toggling.
        if isEnabling {
            UserDefaults.standard.set(["chock"], forKey: "AppleLanguages")
        } else {
            UserDefaults.standard.removeObject(forKey: "AppleLanguages")
        }
        UserDefaults.standard.synchronize()
    }
}

// MARK:- SwiftUI Environment

struct ChocktubaKey: EnvironmentKey {
    static let defaultValue: Bool = Chocktuba.isEnabled
}

extension EnvironmentValues {
    var chocktubaEnabled: Bool {
        get { self[ChocktubaKey.self] }
        set { self[ChocktubaKey.self] = newValue }
    }
}

// MARK:- WordListViewController

class ChocktubaWordListViewController: WordListViewController
{
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let cell = super.tableView(tableView, cellForRowAt: indexPath)
		if Chocktuba.isEnabled
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
		CHOCKTUBA.isHidden = !Chocktuba.isEnabled
		super.viewDidLoad()
	}
}
