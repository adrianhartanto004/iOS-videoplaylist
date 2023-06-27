//
//  UsecaseProvider.swift
//  VideoPlaylistExercise
//
//  Created by Adrian Hartanto on 27/06/23.
//

import Foundation

class UsecaseProvider {
  private static let instance = UsecaseProvider()

  static func getInstance() -> UsecaseProvider {
    return instance
  }

  func provideFetchVideoUsecase() -> FetchVideoUsecase {
    let videoRepository = RepositoryProvider.getInstance().provideVideoRepository()
    return FetchVideoUsecaseImpl(videoRepository: videoRepository)
  }

  func provideGetVideoUsecase() -> GetVideoUsecase {
    let videoRepository = RepositoryProvider.getInstance().provideVideoRepository()
    return GetVideoUsecaseImpl(videoRepository: videoRepository)
  }
}
