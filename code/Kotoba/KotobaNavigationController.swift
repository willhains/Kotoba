//
//  Created by Craig Hockenberry on 11/23/19.
//  Copyright © 2019 Will Hains. All rights reserved.
//

import UIKit

class KotobaNavigationController: UINavigationController
{
	override func viewDidLoad()
	{
		super.viewDidLoad()

		let titleFont = UIFont(name: "AmericanTypewriter-Semibold", size: 22)
			?? UIFont.systemFont(ofSize: 22.0, weight: .bold)
		let barTextColor = UIColor(named: "appBarText") ?? UIColor.white
		self.navigationBar.titleTextAttributes = [.font: titleFont, .foregroundColor: barTextColor]

		let barTintColor = UIColor(named: "appBarTint") ?? UIColor.red
		self.navigationBar.barTintColor = barTintColor
	}

	override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
}
