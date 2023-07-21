import XCTest
import Combine
@testable import VideoPlaylistExercise

class FetchVideoUsecaseTest: XCTestCase {

  private var mockVideoRepository: MockVideoRepository!
  private var sut: FetchVideoUsecase!
  private var cancellables: Set<AnyCancellable> = []

  override func setUp() {
    mockVideoRepository = MockVideoRepository()
    sut = FetchVideoUsecaseImpl(videoRepository: mockVideoRepository)
  }

  override func tearDown() {
    sut = nil
    mockVideoRepository = nil
  }

  func testExecuteSuccess() throws {
    let exp = XCTestExpectation(description: #function)
    var isExecuteCompleted: Bool = false

    mockVideoRepository.whenFetchVideos = Result.success(()).publisher.eraseToAnyPublisher()

    sut
      .execute()
      .sink(
        receiveCompletion: { completion in
          exp.fulfill()
        },
        receiveValue: { _ in
          isExecuteCompleted = true
        }
      )
      .store(in: &cancellables)
    wait(for: [exp], timeout: 1)

    XCTAssertTrue(isExecuteCompleted)
  }
}
