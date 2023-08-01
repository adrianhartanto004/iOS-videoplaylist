import Foundation
import Combine

typealias BaseAPIProtocol = NetworkClientProtocol

typealias AnyPublisherResult<M> = AnyPublisher<M, Error>

protocol NetworkClientProtocol: AnyObject {
  var session: URLSession { get }
}

extension NetworkClientProtocol {
  @available(iOS 13.0, *)
  @discardableResult
  /// Sends the given request.
  /// - parameter request: The request to be sent.
  /// - parameter completion: A callback to invoke when the request completed.
  func perform<M, T>(
    with request: RequestBuilder,
    decoder: JSONDecoder,
    scheduler: T,
    responseObject type: M.Type
  ) -> AnyPublisher<M, Error> where M: Decodable, T: Scheduler {
    let urlRequest = request.buildURLRequest()
    return publisher(request: urlRequest)
      .receive(on: scheduler)
      .map(\.data)
      .decode(type: type.self, decoder: decoder)
      .mapError { error in
        return error as? APIError ?? .general
      }
      .eraseToAnyPublisher()
  }

  private func publisher(request: URLRequest) ->
  AnyPublisher<(data: Data,response: URLResponse), Error> {
    return self.session.dataTaskPublisher(for: request)
      .mapError { APIError.httpCode($0.errorCode) }
      .tryMap {
        assert(!Thread.isMainThread)
        printThreadName("\(#function)")
        printThread("\(#function) urlSession.tryMap")
        guard let httpResponse = $0.response as? HTTPURLResponse else {
          throw APIError.unexpectedResponse
        }
        if !httpResponse.isResponseOK {
          throw APIError.httpCode(httpResponse.statusCode)
        }

        return $0
      }
      .eraseToAnyPublisher()
  }
}
