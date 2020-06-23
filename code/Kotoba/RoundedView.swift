//
// Created by Will Hains on 2020-06-21.
// Copyright (c) 2020 Will Hains. All rights reserved.
//

import UIKit

@IBDesignable class RoundedView: UIView
{
	var enabled: Bool = true
	{
		willSet(newValue)
		{
			layer.opacity = newValue ? 1.0 : 0.3
		}
	}
	
	@IBInspectable var cornerRadius: CGFloat
	{
		get { layer.cornerRadius }
		set
		{
			layer.cornerRadius = newValue
			layer.masksToBounds = newValue > 0
		}
	}
	
	@IBInspectable var borderWidth: CGFloat
	{
		get { layer.borderWidth }
		set { layer.borderWidth = newValue }
	}
	
	@IBInspectable var borderColor: UIColor?
	{
		get { layer.borderColor.map { UIColor(cgColor: $0) } }
		set { layer.borderColor = newValue?.cgColor }
	}
}
