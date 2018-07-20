//
//  UITableView+Additions.swift
//  Kotoba
//
//  Created by Gabor Halasz on 20/07/2018.
//  Copyright © 2018 Will Hains. All rights reserved.
//

import UIKit

extension UITableView {
  func deselect() {
    if let indexPath = indexPathForSelectedRow { deselectRow(at: indexPath, animated: true) }
  }
}
