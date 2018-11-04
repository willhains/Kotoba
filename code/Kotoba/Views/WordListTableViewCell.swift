//
//  WordListTableViewCell.swift
//  Kotoba
//
//  Created by Gabor Halasz on 20/07/2018.
//  Copyright © 2018 Will Hains. All rights reserved.
//

import UIKit
// WH: Where did the WordListVC go? It's disappeared from Main.storyboard!
// GH: I'm sorry, that was out of scoof for this PR and should have definitely
// discussed it with you before. I removed the VC from the storyboard
// out of habbit, got used to not using storyboards too much at my previous
// company, and to do it in code.
// We did this at work to avoud and magic settings to be set in interface builder,
// and to avoid storyboard merge conflicts.

class WordListTableViewCell: UITableViewCell
{
	override init(style: UITableViewCellStyle, reuseIdentifier: String?)
	{
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		super.init(coder: aDecoder)
	}
}
