import Foundation
import Combine
import CoreData

@testable import VideoPlaylistExercise

class MockVideoDao: VideoDao {
  var whenInsertOrReplace: AnyPublisher <Void, Error>!
  var whenFetch: AnyPublisher <[Video], Error>!
  var whenFindByItem: AnyPublisher <VideoENT?, Error>!
  var whenDeleteAll: AnyPublisher <Void, Error>!

  func insertOrReplace(_ item: Video) -> AnyPublisher<Void, Error> {
    return whenInsertOrReplace
  }

  func fetch() -> AnyPublisher<[Video], Error> {
    return whenFetch
  }

  func findByItem(_ id: Int, _ title: String) -> AnyPublisher<VideoENT?, Error> {
    return whenFindByItem
  }
  
  func deleteAll() -> AnyPublisher<Void, Error> {
    return whenDeleteAll
  }
}
