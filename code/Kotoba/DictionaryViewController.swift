//
//  Created by Will Hains on 2020-05-05.
//  Copyright © 2020 Will Hains. All rights reserved.
//

import SwiftUI
import UIKit

class DictionaryViewController: UIReferenceLibraryViewController
{
	var onDismiss: (() -> Void)?

	override init(term: String)
	{
		super.init(term: term)
	}

	required init(coder: NSCoder)
	{
		super.init(coder: coder)
	}

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)

        // Prompt the user to set up their iOS dictionaries, the first time they use this only
        if USER_PREFS.shouldDisplayFirstUseDictionaryPrompt()
        {
            debugLog("First-time lookup. Let's see if the user has dictionaries set up...")
            if !UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: "asdasdasd")
            {
                debugLog("No dictionaries set up. Prompting user.")
                let alert = UIAlertController(
                    title: NSLocalizedString("DICTIONARY_TITLE", comment: "Title for dictionary prompt"),
                    message: NSLocalizedString("DICTIONARY_MESSAGE", comment: "Message for dictionary prompt"),
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(
                    title: NSLocalizedString("DICTIONARY_ACTION", comment: "Action for dictionary prompt"),
                    style: .default,
                    handler: nil))
                self.present(alert, animated: true, completion: nil)
            }

            // Update preferences to silence this prompt next time
            USER_PREFS.didDisplayFirstUseDictionaryPrompt()
        }
    }

	override func viewDidDisappear(_ animated: Bool)
	{
		self.onDismiss?()
	}
}

struct DictionaryView: UIViewControllerRepresentable {
    let term: String

    func makeUIViewController(context: Context) -> DictionaryViewController {
        let vc = DictionaryViewController(term: term.trimmingCharacters(in: .whitespacesAndNewlines))
        vc.modalPresentationStyle = .pageSheet
        return vc
    }

    func updateUIViewController(_ uiViewController: DictionaryViewController, context: Context) {
        // Nothing to update
    }
}
