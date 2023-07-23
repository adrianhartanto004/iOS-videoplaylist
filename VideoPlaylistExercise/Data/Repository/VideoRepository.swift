//
//  VideoRepository.swift
//  VideoPlaylistExercise
//
//  Created by Adrian Hartanto on 27/06/23.
//

import Foundation
import Combine

protocol VideoRepository {
  func fetchVideos() -> AnyPublisher<Void, Error>
  func getVideo() -> AnyPublisher<[Video], Error>
}

final class VideoRepositoryImpl: VideoRepository {
  let videoService: VideoService
  let videoDao: VideoDao

  init(
    videoService: VideoService,
    videoDao: VideoDao
  ) {
    self.videoService = videoService
    self.videoDao = videoDao
  }

  func fetchVideos() -> AnyPublisher<Void, Error> {
    var videos: [Video] = []
    return videoService
      .fetch()
      .flatMap { [weak self] videoListInfo -> AnyPublisher<Void, Error> in
        videos = videoListInfo?.play_list ?? []
        guard let self = self else {
          return Fail.init(
            error: NSError(
              domain: "VideoRepository", code: 0, userInfo: ["message": "nil self"])
          )
          .eraseToAnyPublisher()
        }
        return self.videoDao.insertOrReplace(videos)
      }
      .eraseToAnyPublisher()
  }

  func getVideo() -> AnyPublisher<[Video], Error> {
    return self.videoDao.fetch()
  }
}
