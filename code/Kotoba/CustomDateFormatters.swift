//
//  DateFormatters.swift
//  Kotoba
//
//  Created by Gabor Halasz on 20/07/2018.
//  Copyright © 2018 Will Hains. All rights reserved.
//

import Foundation

// WH: Instead of a Singleton, I prefer to make a value type (struct) for the dictionary lookup date, and move the formatting to a function on the struct, perhaps as an extension. More method-y goodness.
final class CustomDateFormatters
{
	static let shared: CustomDateFormatters = CustomDateFormatters()
	let wordQueryDateFormatter: DateFormatter
	
	private init()
	{
		wordQueryDateFormatter = DateFormatter()
		wordQueryDateFormatter.calendar = Calendar.current
		wordQueryDateFormatter.locale = Locale.current
		wordQueryDateFormatter.dateStyle = .medium
	}
}
