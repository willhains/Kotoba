//
//  AddWordViewControllerTests
//  Kotoba
//
//  Created by Will Hains on 2016-06-25.
//  Copyright © 2016 Will Hains. All rights reserved.
//

import XCTest
@testable import Kotoba

class AddWordViewControllerTests: XCTestCase
{
	func testFilterOnSomeShouldReturnSomeWhenFilterPasses()
	{
		let subject: String? = "a"
		let result: String? = subject.filter { _ in return true }
		XCTAssertNotNil(result)
		XCTAssertEqual(result, "a")
	}
	
	func testFilterOnSomeShouldReturnNoneWhenFilterFails()
	{
		let subject: String? = "a"
		let result: String? = subject.filter { _ in return false }
		XCTAssertNil(result)
	}
	
	func testFilterOnNoneShouldReturnNone()
	{
		let subject: String? = nil
		let result: String? = subject.filter { _ in return true }
		XCTAssertNil(result)
	}
	
	func testFilterOnNoneShouldNotInvokePredicate()
	{
		var invoked = false
		let predicate: (String) -> Bool = { _ in invoked = true; return true }
		let subject: String? = nil
		let result: String? = subject.filter(predicate)
		XCTAssertNil(result)
		XCTAssertFalse(invoked)
	}
}
