//
//  ViewAnimatable.swift
//  Kotoba
//
//  Created by Gabor Halasz on 21/06/2018.
//  Copyright © 2018 Will Hains. All rights reserved.
//

import UIKit

enum ViewAlpha: CGFloat {
  case visible = 1.0
  case hidden = 0.0
}

protocol ViewAnimatable {
  func animate(visible: Bool)
}

extension ViewAnimatable where Self: UIView {
  func animate(visible: Bool) {
    let alpha = visible ? ViewAlpha.visible : ViewAlpha.hidden
    let animator = UIViewPropertyAnimator(duration: 0.25,
                                          curve: .easeIn) {
                                            self.alpha = alpha.rawValue
    }
    animator.startAnimation()
  }
}
