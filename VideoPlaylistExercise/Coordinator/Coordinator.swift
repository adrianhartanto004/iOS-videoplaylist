//
//  Coordinator.swift
//  VideoPlaylistExercise
//
//  Created by Adrian Hartanto on 14/09/23.
//

import Foundation
import UIKit

protocol Coordinator {
  var childCoordinators: [Coordinator] { get set }
  var navigationController: UINavigationController { get set }

  func start()
}
