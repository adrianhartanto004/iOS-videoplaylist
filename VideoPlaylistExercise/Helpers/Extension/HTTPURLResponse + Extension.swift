import Foundation

extension HTTPURLResponse {
  var isResponseOK: Bool {
    return (200..<299).contains(statusCode)
  }
}
