import Foundation

extension NetworkTarget {

  var baseURL: BaseURLType {
    return .baseApi
  }
  
  var bodyEncoding: BodyEncoding? {
    return nil
  }

  var parameters: [String: Any]? {
    return nil
  }

  var cachePolicy: URLRequest.CachePolicy? {
    return .useProtocolCachePolicy
  }

  var timeoutInterval: TimeInterval? {
    return 20.0
  }

  var headers: [String: String]? {
    ["accept": "application/json"]
  }

  var queryParams: [String: String]? {
    return nil
  }
}
