//
//  ViewControllerFactory.swift
//  Kotoba
//
//  Created by Gabor Halasz on 19/07/2018.
//  Copyright © 2018 Will Hains. All rights reserved.
//

import UIKit

final class ViewControllerFactory {
  static func newWordListViewController() -> WordListViewController {
    let wordListViewController = WordListViewController()
    return wordListViewController
  }
}
