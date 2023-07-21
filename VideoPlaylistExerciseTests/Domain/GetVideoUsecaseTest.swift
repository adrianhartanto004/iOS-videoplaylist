import XCTest
import Combine
@testable import VideoPlaylistExercise

class GetVideoUsecaseTest: XCTestCase {

  private var mockVideoRepository: MockVideoRepository!
  private var sut: GetVideoUsecase!
  private var cancellables: Set<AnyCancellable> = []

  override func setUp() {
    mockVideoRepository = MockVideoRepository()
    sut = GetVideoUsecaseImpl(videoRepository: mockVideoRepository)
  }

  override func tearDown() {
    sut = nil
    mockVideoRepository = nil
  }

  func testExecuteSuccess() throws {
    let exp = XCTestExpectation(description: #function)
    let expectedVideos = [createVideo(), createVideo(), createVideo()]
    var actualResult: [Video] = []

    mockVideoRepository.whenGetVideo = Result.success(expectedVideos).publisher.eraseToAnyPublisher()

    sut
      .execute()
      .sink(
        receiveCompletion: { completion in
          exp.fulfill()
        },
        receiveValue: { value in
          actualResult = value
        }
      )
      .store(in: &cancellables)
    wait(for: [exp], timeout: 1)

    XCTAssertEqual(expectedVideos, actualResult)
  }
}
