import Foundation

enum BaseURLType {
  case baseApi

  var desc: URL {
    switch self {
    case .baseApi:
      #if DEBUG
      return URL("https://gist.githubusercontent.com")
      #else
      return URL("https://gist.githubusercontent.com")
      #endif
    }
  }
}

enum VersionType {
  case none
  case v1, v2, v3
  var desc: String {
    switch self {
    case .none:
      return .empty
    case .v1:
      return "/v1"
    case .v2:
      return "/v2"
    case .v3:
      return "/v3"
    }
  }
}
