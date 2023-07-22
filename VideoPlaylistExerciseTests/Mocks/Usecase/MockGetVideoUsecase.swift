import Foundation
import Combine

@testable import VideoPlaylistExercise

class MockGetVideoUsecase: GetVideoUsecase {
  var whenExecute: AnyPublisher<[Video], Error>!

  func execute() -> AnyPublisher<[Video], Error> {
    return whenExecute
  }
}
