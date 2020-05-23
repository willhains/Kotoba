//
//  BartyCrouch.swift
//  Kotoba
//
//  Created by Will Hains on 2020-05-23.
//  Copyright © 2020 Will Hains. All rights reserved.
//

//  This file is required in order for the `transform` task of the translation helper tool BartyCrouch to work.
//  See here for more details: https://github.com/Flinesoft/BartyCrouch

import Foundation

enum BartyCrouch
{
    enum SupportedLanguage: String
	{
		case CHOCK = "chock"
        case english = "en"
    }

    static func translate(key: String, translations: [SupportedLanguage: String], comment: String? = nil) -> String
	{
        let typeName = String(describing: BartyCrouch.self)
        let methodName = #function

        print(
            "Warning: [BartyCrouch]",
            "Untransformed \(typeName).\(methodName) method call found with key '\(key)' and base translations '\(translations)'.",
            "Please ensure that BartyCrouch is installed and configured correctly.")

        // fall back in case something goes wrong with BartyCrouch transformation
        return "BC: TRANSFORMATION FAILED!"
    }
}
