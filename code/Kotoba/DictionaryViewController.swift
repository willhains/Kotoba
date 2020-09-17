//
//  Created by Will Hains on 2020-05-05.
//  Copyright © 2020 Will Hains. All rights reserved.
//

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

	override func viewDidDisappear(_ animated: Bool)
	{
		self.onDismiss?()
	}
}
