import Foundation
import Combine

typealias BaseAPIProtocol = NetworkClientProtocol

typealias AnyPublisherResult<M> = AnyPublisher<M, Error>

protocol NetworkClientProtocol: AnyObject {
  /// Sends the given request.
  ///
  /// - parameter request: The request to be sent.
  /// - parameter completion: A callback to invoke when the request completed.

  var session: URLSession { get }
}

extension NetworkClientProtocol {
  @available(iOS 13.0, *)
  @discardableResult
  func perform<M, T>(
    with request: RequestBuilder,
    decoder: JSONDecoder,
    scheduler: T,
    responseObject type: M.Type
  ) -> AnyPublisher<M, Error> where M: Decodable, T: Scheduler {
    let urlRequest = request.buildURLRequest()
    return publisher(request: urlRequest)
      .receive(on: scheduler)
      .tryMap { result, _ -> Data in
        return result
      }
      .decode(type: type.self, decoder: decoder)
      .mapError { error in
        return error as? APIError ?? .general
      }
      .eraseToAnyPublisher()
  }

  private func publisher(request: URLRequest) ->
    AnyPublisher<(data: Data,response: URLResponse), Error> {
    return self.session.dataTaskPublisher(for: request)
      .mapError { APIError.urlError($0) }
      .flatMap { response -> AnyPublisher<(data: Data, response: URLResponse), Error> in
        assert(!Thread.isMainThread)
        guard let httpResponse = response.response as? HTTPURLResponse else {
          return Fail(error: APIError.invalidResponse(httpStatusCode: 0))
            .eraseToAnyPublisher()
        }

        if !httpResponse.isResponseOK {
          let error = NetworkClient.errorType(type: httpResponse.statusCode)
          return Fail(error: error)
            .eraseToAnyPublisher()
        }

        return Just(response)
          .setFailureType(to: Error.self)
          .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
}
