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
		let barTintColor = UIColor(named: "appBarTint") ?? UIColor.red

		let titleTextAttributes: [NSAttributedString.Key : Any] = [
			.font: titleFont,
			.foregroundColor: barTextColor,
		]

		if #available(iOS 15, *) {
			// NOTE: The following code is derived from David Duncan's post in the Apple Developer Forums:
			// https://developer.apple.com/forums/thread/682420

			let appearance = UINavigationBarAppearance()
			appearance.configureWithOpaqueBackground()
			appearance.backgroundColor = barTintColor
			appearance.titleTextAttributes = titleTextAttributes
			
			navigationBar.standardAppearance = appearance;
			navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
		}
		else {
			self.navigationBar.titleTextAttributes = titleTextAttributes
			self.navigationBar.barTintColor = barTintColor
		}
	}

	override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
}
