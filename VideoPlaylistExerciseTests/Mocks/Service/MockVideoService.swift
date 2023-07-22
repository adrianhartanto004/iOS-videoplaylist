import Foundation
import Combine

@testable import VideoPlaylistExercise

class MockVideoService: VideoService {
  var whenFetchedResult: AnyPublisher <VideoListInfo?, Error>!

  func fetch() -> AnyPublisher<VideoListInfo?, Error> {
    return whenFetchedResult
  }
}
