import XCTest
import Combine
@testable import VideoPlaylistExercise

class VideoRepositoryTest: XCTestCase {

  private var mockVideoService: MockVideoService!
  private var mockVideoDao: MockVideoDao!
  private var cancellables: Set<AnyCancellable> = []

  private var sut: VideoRepository!

  override func setUp() {
    mockVideoService = MockVideoService()
    mockVideoDao = MockVideoDao()
    sut = VideoRepositoryImpl(videoService: mockVideoService, videoDao: mockVideoDao)
  }

  override func tearDown() {
    sut = nil
    mockVideoService = nil
    mockVideoDao = nil
  }

  func testFetchVideosSuccess() throws {
    let expectedVideoListInfo = VideoListInfo.videoListInfoMockData
    let exp = XCTestExpectation(description: #function)
    var isFetchCompleted: Bool = false

    mockVideoService.whenFetchedResult = Result.success(expectedVideoListInfo).publisher.eraseToAnyPublisher()
    mockVideoDao.whenDeleteAll = Result.success(()).publisher.eraseToAnyPublisher()
    mockVideoDao.whenInsertOrReplace = Result.success(()).publisher.eraseToAnyPublisher()

    sut
      .fetchVideos()
      .sink(
        receiveCompletion: { completion in
          exp.fulfill()
        },
        receiveValue: { _ in
          isFetchCompleted = true
        }
      )
      .store(in: &cancellables)
    wait(for: [exp], timeout: 1)

    XCTAssertTrue(isFetchCompleted)
  }

  func testGetVideoSuccess() throws {
    let expectedVideos = Video.videoInfoMockData
    let exp = XCTestExpectation(description: #function)
    var actualResult: [Video] = []

    mockVideoDao.whenFetch = Result.success(expectedVideos).publisher.eraseToAnyPublisher()

    sut
      .getVideo()
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
