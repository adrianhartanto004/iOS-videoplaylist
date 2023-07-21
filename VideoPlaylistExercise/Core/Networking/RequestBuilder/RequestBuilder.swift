import Foundation

protocol RequestBuilder: NetworkTarget {
  init(request: NetworkTarget)
  var pathAppendedURL: URL { get }
  func setQueryTo(urlRequest: inout URLRequest,
                  urlEncoding: URLEncoding,
                  queryParams: [String: String])
  func encodedBody(bodyEncoding: BodyEncoding, requestBody: [String: Any]) -> Data?
  func buildURLRequest() -> URLRequest
}
