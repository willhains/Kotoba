//
//  KotobaAppStoreScreenshots.swift
//  KotobaUITests
//
//  Created by Will Hains on 2020-02-05.
//  Copyright © 2020 Will Hains. All rights reserved.
//

import XCTest
@testable import Kotoba

class KotobaAppStoreScreenshots: XCTestCase
{
	var prevClipboard: [[String: Any]] = []

	override func setUp()
	{
		super.setUp()

		// In UI tests it is usually best to stop immediately when a failure occurs.
		continueAfterFailure = false

		// Set clipboard contents
		prevClipboard = UIPasteboard.general.items
		UIPasteboard.general.string =
			"""
			lubricious
			apéritif
			hässlich
			林檎
			zephyr
			sagacious
			hobnob
			riposte
			hibernaculum
			effervescent
			festal
			roman
			snarf
			spoonerism
			bonhomie
			fastigiate
			"""

		// UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
		let app = XCUIApplication()
		app.launchArguments = ["UITEST"]
		app.launch()

		// In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
		let enableICloudButton = app.buttons["Sync Data via iCloud"]
		if enableICloudButton.exists { enableICloudButton.tap() }
		if !app.keys["s"].waitForExistence(timeout: 1)
		{
			XCTFail("The software keyboard could not be found.  Use Xcode Simulator settings to turn off hardware keyboard (Keyboard shortcut COMMAND + SHIFT + K while simulator has focus)")
		}
	}

	override func tearDown()
	{
		// Restore clipboard contents
		UIPasteboard.general.setItems(prevClipboard)
	}

	func testTakeAppStoreScreenshots()
	{
		let app = XCUIApplication()

		// Main screen
		let textField = app.textFields["Type a Word"]
		sleep(2)
		takeScreenshot(name: "Type A Word")
		XCTAssert(textField.exists)

		// Settings screen
		app.buttons["Settings"].tap()
		sleep(1)
		takeScreenshot(name: "Settings")
		app/*@START_MENU_TOKEN@*/.otherElements["clipboardButton"]/*[[".otherElements[\"Clipboard Import\"]",".otherElements[\"clipboardButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
		app.buttons["OK"].tap()
		var doneButton = app.buttons["Done"]
		XCTAssert(doneButton.exists)
		doneButton.tap()

		// Word History screen
		app.buttons["History"].tap()
		sleep(1)
		takeScreenshot(name: "History")
		doneButton = app.buttons["Done"]
		XCTAssert(doneButton.exists)
		doneButton.tap()
	}
}

extension XCTestCase
{
	func takeScreenshot(name: String)
	{
		let filename = "Screenshot-\(UIDevice.current.name)-\(name)".replacingOccurrences(of: " ", with: "_")
		let fullScreenshot = XCUIScreen.main.screenshot()
		let screenshot = XCTAttachment(
			uniformTypeIdentifier: "public.png",
			name: "\(filename).png",
			payload: fullScreenshot.pngRepresentation,
			userInfo: nil)
		screenshot.lifetime = .keepAlways
		add(screenshot)
	}
}
