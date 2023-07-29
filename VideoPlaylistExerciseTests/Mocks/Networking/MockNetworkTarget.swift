import Foundation
@testable import VideoPlaylistExercise

class MockNetworkTarget: NetworkTarget {
  var baseURL: BaseURLType = .baseApi

  var version: VersionType = .none

  var path: String? = "/adrianhartanto004/ef1cfab2cb0ccb9258dcde7afbb8543e/raw/"

  var methodType: HTTPMethod = .get

  var queryParams: [String : String]? = ["test": "test"]

  var queryParamsEncoding: URLEncoding? = .default
}
