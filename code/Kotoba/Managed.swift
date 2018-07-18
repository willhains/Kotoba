//
//  Managed.swift
//  Kotoba
//
//  Created by Gabor Halasz on 18/07/2018.
//  Copyright © 2018 Will Hains. All rights reserved.
//

import Foundation
import CoreData

protocol Maanged {
  var entityName: String { get }
  var defaultSortDescriptors: [NSSortDescriptor] { get }
}
