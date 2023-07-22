import Foundation
import Combine

@testable import VideoPlaylistExercise

class MockVideoRepository: VideoRepository {
  var whenFetchVideos: AnyPublisher <Void, Error>!
  var whenGetVideo: AnyPublisher <[Video], Error>!

  func fetchVideos() -> AnyPublisher<Void, Error> {
    return whenFetchVideos
  }

  func getVideo() -> AnyPublisher<[Video], Error> {
    return whenGetVideo
  }
}
