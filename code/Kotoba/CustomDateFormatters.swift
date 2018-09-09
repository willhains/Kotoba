//
//  DateFormatters.swift
//  Kotoba
//
//  Created by Gabor Halasz on 20/07/2018.
//  Copyright © 2018 Will Hains. All rights reserved.
//

import Foundation

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
