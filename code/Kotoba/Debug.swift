//
//  Debug.swift
//  Linea
//
//  Created by Craig Hockenberry on 10/4/19.
//
//  Usage:
//    debugLog("reticulating splines")  prints "2019-10-04 11:52:28 SplineReticulationManager: reticulationFunction reticulating splines"
//    debugLog()                        prints "2019-10-04 11:52:28 SplineReticulationManager: reticulationFunction called"

import Foundation

func releaseLog(_ message: String = "called", file: String = #file, function: String = #function) {
	let timestamp = ISO8601DateFormatter.string(from: Date(), timeZone: TimeZone.current, formatOptions: [.withYear, .withMonth, .withDay, .withDashSeparatorInDate, .withTime, .withColonSeparatorInTime, .withSpaceBetweenDateAndTime])
	print("\(timestamp) \(URL(fileURLWithPath: file).deletingPathExtension().lastPathComponent): \(function) \(message)")
}

func debugLog(_ message: String = "called", file: String = #file, function: String = #function) {
	#if DEBUG
		let timestamp = ISO8601DateFormatter.string(from: Date(), timeZone: TimeZone.current, formatOptions: [.withYear, .withMonth, .withDay, .withDashSeparatorInDate, .withTime, .withColonSeparatorInTime, .withSpaceBetweenDateAndTime])
		print("\(timestamp) \(URL(fileURLWithPath: file).deletingPathExtension().lastPathComponent): \(function) \(message)")
	#endif
}

#if true
	
// weed out NSLog usage
@available(iOS, deprecated: 1.0, message: "Convert to debugLog")
public func NSLog(_ format: String, _ args: CVarArg...)
{
}
	
#endif
