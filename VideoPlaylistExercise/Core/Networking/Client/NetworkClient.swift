import Foundation
import Combine

final class NetworkClient: NetworkClientProtocol {
  
  /// Initializes a new URL Session Client.
  ///
  /// - parameter urlSession: The URLSession to use.
  ///     Default: `URLSession(configuration: .shared)`.
  ///
  let session: URLSession

  init(
    session: URLSession = .shared
  ) {
    self.session = session
  }
}
