//
//  WordListTableViewCell.swift
//  Kotoba
//
//  Created by Gabor Halasz on 20/07/2018.
//  Copyright © 2018 Will Hains. All rights reserved.
//

import UIKit
// WH: Where did the WordListVC go? It's disappeared from Main.storyboard!

class WordListTableViewCell: UITableViewCell
{
	override init(style: UITableViewCellStyle, reuseIdentifier: String?)
	{
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		// WH: Can we just call super.init(coder: aDecoder) instead of fatalError?
		fatalError("init(coder:) has not been implemented")
	}
	
	// WH: Isn't this redundant?
	override func awakeFromNib()
	{
		super.awakeFromNib()
		// Initialization code
	}
	
	// WH: Isn't this redundant?
	override func setSelected(_ selected: Bool, animated: Bool)
	{
		super.setSelected(selected, animated: animated)
	}
}
