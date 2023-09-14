//
//  VideoCoordinator.swift
//  VideoPlaylistExercise
//
//  Created by Adrian Hartanto on 14/09/23.
//

import Foundation
import UIKit

class VideoCoordinator: Coordinator {
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    let vc = VideoHomeViewController.instantiate("Main")
    vc.coordinator = self
    navigationController.pushViewController(vc, animated: true)
  }

  func goToDetailScreen(_ video: Video) {
    let vc = VideoDetailController.instantiate("VideoDetail")
    vc.coordinator = self
    vc.video = video
    navigationController.pushViewController(vc, animated: true)
  }

  func popToRootController() {
    navigationController.popViewController(animated: true)
  }
}
