//
//  UIColourTheme.swift
//  Kotoba
//
//  Created by Will Hains on 2018-10-14.
//  Copyright © 2018 Will Hains. All rights reserved.
//

import UIKit

struct UIColourTheme
{
	let mainColour: UIColor
	
	init(hue: CGFloat, saturation: CGFloat, brightness: CGFloat)
	{
		mainColour = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
	}
	
	func applyTint()
	{
		UIView.appearance().tintColor = mainColour
	}
}
