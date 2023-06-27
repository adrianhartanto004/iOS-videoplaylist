import Foundation
@testable import VideoPlaylistExercise

class MockNetworkTarget: NetworkTarget {
  var baseURL: BaseURLType = .baseApi

  var version: VersionType = .none

  var path: String? = "/ayinozendy/a1f7629d8760c0d9cd4a5a4f051d111c/raw/"

  var methodType: HTTPMethod = .get

  var queryParams: [String : String]? = ["test": "test"]

  var queryParamsEncoding: URLEncoding? = .default
}
