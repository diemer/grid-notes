//
//  CGFloat+extension.swift
//  Grid Notes
//
//  Created by Dan Diemer on 4/23/22.
//

import Foundation
import CoreGraphics

extension CGFloat {
  public static func round(_ value: Double, toNearest: Double) -> Double {
    return Darwin.round(value / toNearest) * toNearest
  }
  
}
