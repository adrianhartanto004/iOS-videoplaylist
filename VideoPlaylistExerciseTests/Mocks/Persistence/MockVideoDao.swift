import Foundation
import Combine
import CoreData

@testable import VideoPlaylistExercise

class MockVideoDao: VideoDao {
  var whenInsertOrReplace: AnyPublisher <Void, Error>!
  var whenFetch: AnyPublisher <[Video], Error>!
  var whenFindByItemTaskPublisher: AnyPublisher <VideoENT?, Never>!
  var whenDeleteAll: AnyPublisher <Void, Error>!

  func insertOrReplace(_ items: [VideoPlaylistExercise.Video]) -> AnyPublisher<Void, Error> {
    return whenInsertOrReplace
  }

  func fetch() -> AnyPublisher<[Video], Error> {
    return whenFetch
  }

  func findByItemTaskPublisher(_ id: Int, _ title: String) -> AnyPublisher<VideoPlaylistExercise.VideoENT?, Never> {
    return whenFindByItemTaskPublisher
  }
  
  func deleteAll() -> AnyPublisher<Void, Error> {
    return whenDeleteAll
  }
}
