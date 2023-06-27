//
//  RepositoryProvider.swift
//  VideoPlaylistExercise
//
//  Created by Adrian Hartanto on 26/06/23.
//

import Foundation

class RepositoryProvider {
  private static let instance = RepositoryProvider()

  static func getInstance() -> RepositoryProvider {
    return instance
  }

  func provideVideoRepository() -> VideoRepository {
    let videoService = ServiceProvider.getInstance().provideVideoService()
    let videoDao = DatabaseProvider.getInstance().provideVideoDao()
    return VideoRepositoryImpl(videoService: videoService, videoDao: videoDao)
  }
}
