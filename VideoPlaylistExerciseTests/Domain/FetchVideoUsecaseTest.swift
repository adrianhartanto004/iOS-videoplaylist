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

  func test_execute_shouldReturnCompleted() throws {
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

  func test_execute_error() throws {
    let exp = XCTestExpectation(description: #function)
    var isExecuteCompleted: Bool = false
    let error = APIError.noNetwork

    mockVideoRepository.whenFetchVideos = Result.failure(error).publisher.eraseToAnyPublisher()

    sut
      .execute()
      .sink(
        receiveCompletion: { completion in
          switch completion {
          case .finished:
            break
          case .failure(let failure):
            XCTAssertEqual(error.localizedDescription, failure.localizedDescription)
          }
          exp.fulfill()
        },
        receiveValue: { _ in
          isExecuteCompleted = true
        }
      )
      .store(in: &cancellables)
    wait(for: [exp], timeout: 1)

    XCTAssertFalse(isExecuteCompleted)
  }
}
