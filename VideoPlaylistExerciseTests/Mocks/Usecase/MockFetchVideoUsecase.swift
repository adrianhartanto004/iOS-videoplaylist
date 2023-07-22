import Foundation
import Combine

@testable import VideoPlaylistExercise

class MockFetchVideoUsecase: FetchVideoUsecase {
  var whenExecute: AnyPublisher <Void, Error>!

  func execute() -> AnyPublisher<Void, Error> {
    return whenExecute
  }
}
