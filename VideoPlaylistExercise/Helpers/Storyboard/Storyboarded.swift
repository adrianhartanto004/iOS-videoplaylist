//
//  Storyboarded.swift
//  VideoPlaylistExercise
//
//  Created by Adrian Hartanto on 14/09/23.
//

import Foundation
import UIKit

protocol Storyboarded {
  static func instantiate(_ storyboardName: String) -> Self
}

extension Storyboarded where Self: UIViewController {
  static func instantiate(_ storyboardName: String) -> Self {
    let id = String(describing: self)
    let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)

    return storyboard.instantiateViewController(withIdentifier: id) as! Self
  }
}
