//
//  PasteboardWatcher.swift
//  PasteboardWatcher
//
//  Created by Devarshi Kulshreshtha on 6/19/15.PasteboardWatcher
//  Copyright © 2015 Devarshi Kulshreshtha. All rights reserved.
//

import UIKit

/// Protocol defining the methods which delegate has/can implement
protocol PasteboardWatcherDelegate
{
	/// the method which is invoked on delegate when a new string is copied
	/// - Parameter newValue: the newly copied string value
	func pasteboardStringDidChange(newValue: String)
}

/// Use this class to notify a delegate once a string is copied
/// - Credit goes to: **Josh Goebel**
/// - His wonderful pastie: [PasteboardWatcher in objective-c](http://pastie.org/1129293)
class PasteboardWatcher
{
	// assigning a pasteboard object
	private let pasteboard = UIPasteboard.general
	
	// to keep track of count of objects currently copied
	// also helps in determining if a new object is copied
	private var changeCount: Int
	
	// used to perform polling (gross, but there's no other way?)
	private var timer: Timer?
	
	// the delegate which will be notified when desired link is copied
	var delegate: PasteboardWatcherDelegate?
	
	/// initializer which should be used to initialize object of this class
	init()
	{
		// assigning current pasteboard changeCount so that it can be compared later to identify changes
		changeCount = pasteboard.changeCount
	}
	
	/// starts polling to identify if url with desired kind is copied
	/// - Note: uses an NSTimer for polling
	func startPolling(every interval: Double)
	{
		// setup and start of timer
		timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(checkForChangesInPasteboard), userInfo: nil, repeats: true)
	}
	
	/// method invoked continuously by timer
	/// - Note: To keep this method as private I referred this answer at stackoverflow - [Swift - NSTimer does not invoke a private func as selector](http://stackoverflow.com/a/30947182/217586)
	@objc private func checkForChangesInPasteboard()
	{
		// check if there is any new item copied
		// also check if kind of copied item is string
		if let copiedString = pasteboard.string, pasteboard.changeCount != changeCount
		{
			// invoke appropriate method on delegate
			self.delegate?.pasteboardStringDidChange(newValue: copiedString)
		}
		
		// assign new change count to instance variable for later comparison
		changeCount = pasteboard.changeCount
	}
}
