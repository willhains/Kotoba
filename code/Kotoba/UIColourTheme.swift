//
//  UIColourTheme.swift
//  Kotoba
//
//  Created by Will Hains on 2018-10-14.
//  Copyright © 2018 Will Hains. All rights reserved.
//

import UIKit

/// A colour theme for the application.
struct UIColourTheme
{
	/// The main colour of the theme. Used for UIKit tint colour.
	let mainColour: UIColor
	
	init(hue: CGFloat, saturation: CGFloat, brightness: CGFloat)
	{
		mainColour = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
	}
	
	/// Apply the `mainColour` as the UIKit-wide tint colour.
	func applyTint()
	{
		UIView.appearance().tintColor = mainColour
	}
}
