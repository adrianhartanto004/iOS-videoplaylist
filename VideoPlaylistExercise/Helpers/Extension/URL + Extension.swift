import Foundation

extension URL {
  init(_ string: StaticString) {
    self.init(string: "\(string)")!
  }
}
