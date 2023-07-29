import XCTest
@testable import VideoPlaylistExercise

final class RequestBuilderTest: XCTestCase {
  var sut: HttpRequest!

  override func setUp() {
    sut = HttpRequest(request: MockNetworkTarget())
  }

  override func tearDown() {
    sut = nil
    super.tearDown()
  }

  func testRequestBuilder_WhenBaseURl_ShouldReturnType() {
    XCTAssertEqual(sut.baseURL, .baseApi)
  }

  func testRequestBuilder_WhenVersion_ShouldReturnType() {
    XCTAssertEqual(sut.version, .none)
  }

  func testRequestBuilder_WhenPath_ShouldReturnString() {
    XCTAssertEqual(sut.path, "/adrianhartanto004/ef1cfab2cb0ccb9258dcde7afbb8543e/raw/")
  }

  func testRequestBuilder_WhenMethodType_ShouldReturnType() {
    XCTAssertEqual(sut.methodType, .get)
  }

  func testRequestBuilder_WhenMethodQuery_ShouldReturnStringDictionary() {
    XCTAssertEqual(sut.queryParams, ["test":"test"])
  }

  func testRequestBuilder_WhenEncoding_ShouldReturnEncoding() {
    XCTAssertEqual(sut.queryParamsEncoding, .default)
  }

  func testRequestBuilder_WhenPathAppender_ShouldReturnString() {
    XCTAssertEqual(sut.pathAppendedURL, URL("https://gist.githubusercontent.com/adrianhartanto004/ef1cfab2cb0ccb9258dcde7afbb8543e/raw/"))
  }

  func testRequestBuilder_WhenBuildURL_ShouldBeURLRequest() {
    XCTAssertTrue(sut.buildURLRequest() as Any is URLRequest)
  }
}
