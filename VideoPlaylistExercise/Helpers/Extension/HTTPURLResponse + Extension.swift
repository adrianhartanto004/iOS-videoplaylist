import Foundation

extension HTTPURLResponse {
  var isResponseOK: Bool {
    return (200 ..< 300).contains(statusCode)
  }
}
