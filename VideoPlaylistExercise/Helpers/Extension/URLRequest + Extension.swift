import Foundation

#if canImport(Combine)
public extension URLRequest {
  @available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
  var dataTaskPublisher: URLSession.DataTaskPublisher {
    URLSession.shared.dataTaskPublisher(for: self)
  }
}
#endif
