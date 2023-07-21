//
//  GetVideoUsecase.swift
//  VideoPlaylistExercise
//
//  Created by Adrian Hartanto on 27/06/23.
//

import Foundation
import Combine

protocol GetVideoUsecase: AnyObject {
  func execute() -> AnyPublisher<[Video], Error>
}

final class GetVideoUsecaseImpl: GetVideoUsecase {
  let videoRepository: VideoRepository

  init(videoRepository: VideoRepository) {
    self.videoRepository = videoRepository
  }

  func execute() -> AnyPublisher<[Video], Error> {
    return videoRepository.getVideo()
  }
}
