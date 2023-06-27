import XCTest
import Combine
@testable import VideoPlaylistExercise

class VideoServiceTest: XCTestCase {

  private var mockNetworkClient: MockNetworkClient!
  private var cancellables: Set<AnyCancellable> = []

  private var sut: VideoService!

  override func setUp() {
    mockNetworkClient = MockNetworkClient()
    sut = VideoServiceImpl(clientURLSession: mockNetworkClient)
  }

  override func tearDown() {
    sut = nil
    RequestMocking.removeAllMocks()
  }

  func testVideoServiceFetchDataSuccess() throws {
    let expectedVideoListInfo = VideoListInfo.videoListInfoMockData
    let exp = XCTestExpectation(description: #function)
    var actualResult: VideoListInfo?

    try mockNetworkClient.mock(
      request: HttpRequest(request: VideoRequest()),
      fileName: "VideoListInfoResponse",
      type: VideoListInfo.self
    )

    sut
      .fetch()
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

    XCTAssertEqual(expectedVideoListInfo, actualResult)
  }
}
