//
//  ServiceProvider.swift
//  VideoPlaylistExercise
//
//  Created by Adrian Hartanto on 26/06/23.
//

import Foundation

class ServiceProvider {
  private static let instance = ServiceProvider()

  static func getInstance() -> ServiceProvider {
    return instance
  }

  func provideVideoService() -> VideoService {
    return VideoServiceImpl()
  }
}
