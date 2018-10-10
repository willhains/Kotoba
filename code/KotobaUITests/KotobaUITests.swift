//
//  KotobaUITests.swift
//  KotobaUITests
//
//  Created by Will Hains on 2016-06-25.
//  Copyright © 2016 Will Hains. All rights reserved.
//

import XCTest
@testable import Kotoba

class KotobaUITests: XCTestCase
{
    override func setUp()
	{
        super.setUp()
		
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
		
        // UI tests must launch the application that they test.
		// Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
		app.launchArguments = ["UITEST"]
		app.launch()
		
		// Ensure there is at least one English dictionary
		app.toolbars["Toolbar"].buttons["Manage"].tap()
		let downloadButton = app.tables.cells
			.containing(.staticText, identifier:"American English")
			.firstMatch
			.buttons["Download Dictionary"]
		if downloadButton.exists { downloadButton.tap() }
		app.navigationBars.buttons.element(boundBy: 0).tap()
		app.buttons["Done"].tap()
    }
	
	private func _enter(word: String)
	{
		let app = XCUIApplication()
		let textField = app.textFields["Type a Word"]
		textField.clear()
		textField.typeText("\(word)\r")
	}
	
	private func _dismissFirstTimeDictionaryPrompt()
	{
		let app = XCUIApplication()
		let gotIt = app.buttons["Got It"]
		if gotIt.exists { gotIt.tap() }
	}
	
	private func _closeDictionary()
	{
		_dismissFirstTimeDictionaryPrompt()
		let app = XCUIApplication()
		let done = app.buttons["Done"]
		done.tap()
	}
	
	private func _showHistory()
	{
		let app = XCUIApplication()
		let history = app.buttons["History"]
		history.tap()
	}
	
	private func _assertTableContents(_ words: String...)
	{
		let app = XCUIApplication()
		let table = app.tables.element
		XCTAssert(table.exists)
		let cellCount: UInt = UInt(table.cells.count)
		let wordCount: UInt = UInt(words.count)
		XCTAssert(cellCount == wordCount)
		for (index, word) in words.enumerated()
		{
			let cell = table.cells.element(boundBy: index)
			let text = cell.staticTexts[word]
			XCTAssert(text.exists)
		}
	}
	
    func testShouldDisplayDictionaryDownloadPromptOnlyFirstTime()
	{
		let app = XCUIApplication()
		_enter(word: "test")
		
		let gotItButton = app.buttons["Got It"]
		XCTAssert(gotItButton.exists)
		
		gotItButton.tap()
		app.buttons["Done"].tap()
		_enter(word: "another")
		XCTAssert(app.alerts.count == 0)
	}
	
	func testHistoryShouldBeEmpty()
	{
		let app = XCUIApplication()
		_showHistory()
		
		let table = app.tables.element
		XCTAssert(table.exists)
		XCTAssert(table.cells.count == 0)
	}
	
	func testHistoryShowsAddedWordsInReverseOrder()
	{
		let app = XCUIApplication()
		_enter(word: "one")
		_closeDictionary()
		_enter(word: "two")
		_closeDictionary()
		_enter(word: "three")
		_closeDictionary()
		_showHistory()
		_assertTableContents("three", "two", "one")
		
		app.navigationBars.buttons["Word Lookup"].tap()
		_enter(word: "two")
		_closeDictionary()
		_showHistory()
		
		// Should move duplicate entry to top
		_assertTableContents("two", "three", "one")
	}
	
	func testTappingWordInHistoryShowsDefinition()
	{
		let app = XCUIApplication()
		_enter(word: "one")
		_closeDictionary()
		_showHistory()
		
		let table = app.tables.element
		let oneCell = table.cells.element
		oneCell.tap()
		
		sleep(1)
		
		XCTAssert(app.buttons["Manage"].exists)
	}
	
	func testDeleteWords()
	{
		let app = XCUIApplication()
		_enter(word: "one")
		_closeDictionary()
		_enter(word: "two")
		_closeDictionary()
		_enter(word: "three")
		_closeDictionary()
		_showHistory()
		
		// Swipe left to delete
		let table = app.tables.element
		table.cells.element(boundBy: 1).swipeLeft()
		app.buttons["Delete"].tap()
		XCTAssert(table.cells.count == 2)
		
		// Edit mode to delete
		app.buttons["Edit"].tap()
		table.buttons["Delete one"].tap()
		table.buttons["Delete"].tap()
		app.buttons["Done"].tap()
		XCTAssert(table.cells.count == 1)
	}
}

// from https://stackoverflow.com/a/32894080
extension XCUIElement
{
	func clear()
	{
		guard let stringValue = self.value as? String else
		{
			XCTFail("Tried to clear and enter text into a non string value")
			return
		}
		let deleteString = stringValue
			.map { _ in XCUIKeyboardKey.delete }
			.map { $0.rawValue }
			.joined(separator: "")
		self.typeText(deleteString)
	}
}
