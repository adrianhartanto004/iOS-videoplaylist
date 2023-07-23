import XCTest
import Combine
@testable import VideoPlaylistExercise

class VideoHomeViewModelTest: XCTestCase {

  private var mockFetchVideoUsecase: MockFetchVideoUsecase!
  private var mockGetVideoUsecase: MockGetVideoUsecase!

  private var cancellables: Set<AnyCancellable> = []

  private var sut: VideoHomeViewModel!

  override func setUp() {
    mockFetchVideoUsecase = MockFetchVideoUsecase()
    mockGetVideoUsecase = MockGetVideoUsecase()
    sut = VideoHomeViewModel(mockFetchVideoUsecase, mockGetVideoUsecase)
  }

  override func tearDown() {
    sut = nil
    mockFetchVideoUsecase = nil
    mockGetVideoUsecase = nil
  }

  func testRefreshVideosSuccess() throws {
    let expectedVideos = [createVideo(), createVideo(), createVideo()]
    let loadingExp = XCTestExpectation(description: #function)
    let videosExp = XCTestExpectation(description: #function)
    var actualResult: [Video] = []

    mockFetchVideoUsecase.whenExecute = Result.success(()).publisher.eraseToAnyPublisher()
    mockGetVideoUsecase.whenExecute = Result.success(expectedVideos).publisher.eraseToAnyPublisher()

    sut.refreshVideos()
    XCTAssertTrue(sut.isLoading)
    XCTAssertNil(sut.error)

    sut.$isLoading
      .dropFirst()
      .sink { isLoading in
        XCTAssertFalse(isLoading)
        loadingExp.fulfill()
      }
      .store(in: &cancellables)

    sut.$videos
      .dropFirst()
      .sink { videos in
        actualResult = videos
        XCTAssertNil(self.sut.error)
        videosExp.fulfill()
      }
      .store(in: &cancellables)
    wait(for: [loadingExp, videosExp], timeout: 5)

    XCTAssertEqual(expectedVideos, actualResult)
  }

  func testRefreshVideosError() throws {
    let exp = XCTestExpectation(description: #function)
    let error = NSError.test

    mockFetchVideoUsecase.whenExecute = Result.failure(error).publisher.eraseToAnyPublisher()

    sut.refreshVideos()
    XCTAssertTrue(sut.isLoading)
    XCTAssertNil(sut.error)

    sut.$error
      .dropFirst()
      .sink { error in
        XCTAssertNotNil(error)
        exp.fulfill()
      }
      .store(in: &cancellables)
    wait(for: [exp], timeout: 5)

    XCTAssertNotNil(sut.error)
  }

  func testLoadVideosSuccess() throws {
    let expectedVideos = [createVideo(), createVideo(), createVideo()]
    let videosExp = XCTestExpectation(description: #function)
    var actualResult: [Video] = []

    mockGetVideoUsecase.whenExecute = Result.success(expectedVideos).publisher.eraseToAnyPublisher()

    sut.loadVideos()
    XCTAssertTrue(sut.isLoading)
    XCTAssertNil(sut.error)

    sut.$videos
      .dropFirst()
      .sink { videos in
        actualResult = videos
        XCTAssertNil(self.sut.error)
        videosExp.fulfill()
      }
      .store(in: &cancellables)
    wait(for: [videosExp], timeout: 5)

    XCTAssertEqual(expectedVideos, actualResult)
  }

  func testLoadVideosError() throws {
    let exp = XCTestExpectation(description: #function)
    let error = NSError.test

    mockGetVideoUsecase.whenExecute = Result.failure(error).publisher.eraseToAnyPublisher()

    sut.loadVideos()
    XCTAssertTrue(sut.isLoading)
    XCTAssertNil(sut.error)

    sut.$error
      .dropFirst()
      .sink { error in
        XCTAssertNotNil(error)
        exp.fulfill()
      }
      .store(in: &cancellables)
    wait(for: [exp], timeout: 5)

    XCTAssertNotNil(sut.error)
  }
}
