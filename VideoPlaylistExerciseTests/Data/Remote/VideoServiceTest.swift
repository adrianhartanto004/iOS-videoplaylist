import XCTest
import Combine
@testable import VideoPlaylistExercise

class VideoServiceTest: XCTestCase, TestHelper {

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

  func test_fetchData_shouldReturnData() throws {
    let expectedVideoListInfo = decodeJSONFile(
      filename: "VideoListInfoResponse", type: VideoListInfo.self
    )
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

  func test_fetchData_networkError() throws {
    let exp = XCTestExpectation(description: #function)
    let expectedError = APIError.noNetwork

    try mockNetworkClient.mockError(
      request: HttpRequest(request: VideoRequest()),
      error: expectedError,
      httpCode: -1009
    )

    sut
      .fetch()
      .sink(
        receiveCompletion: { completion in
          exp.fulfill()
          switch completion {
          case .finished:
            break
          case .failure(let error):
            XCTAssertEqual(
              expectedError.localizedDescription,
              error.localizedDescription
            )
          }
        },
        receiveValue: { value in
        }
      )
      .store(in: &cancellables)
    wait(for: [exp], timeout: 1)
  }
}
