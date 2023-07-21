//
//  FetchVideoUsecase.swift
//  VideoPlaylistExercise
//
//  Created by Adrian Hartanto on 27/06/23.
//

import Foundation
import Combine

protocol FetchVideoUsecase: AnyObject {
  func execute() -> AnyPublisher<Void, Error>
}

final class FetchVideoUsecaseImpl: FetchVideoUsecase {
  let videoRepository: VideoRepository

  init(videoRepository: VideoRepository) {
    self.videoRepository = videoRepository
  }

  func execute() -> AnyPublisher<Void, Error> {
    return videoRepository.fetchVideos()
  }
}
