//
//  Created by Will Hains on 2016-06-20.
//  Copyright © 2016 Will Hains. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController
{
	/// Present the system dictionary as a modal view, showing the definition of `word`.
	/// - returns: `true` if the system dictionary found a definition, `false` otherwise.
	func showDefinition(forWord word: Word, completion: (() -> Void)? = nil)
	{
		let dictionaryViewController = DictionaryViewController(term: word.text)
		dictionaryViewController.modalPresentationStyle = .pageSheet
		self.present(dictionaryViewController, animated: true, completion: completion)
	}
}
