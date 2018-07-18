//
//  Managed.swift
//  Kotoba
//
//  Created by Gabor Halasz on 18/07/2018.
//  Copyright © 2018 Will Hains. All rights reserved.
//

import Foundation
import CoreData

protocol Managed {
  static var entityName: String { get }
  static var defaultSortDescriptors: [NSSortDescriptor] { get }
}
