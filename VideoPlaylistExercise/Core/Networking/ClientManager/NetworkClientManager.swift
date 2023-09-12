import Foundation
import Combine

class NetworkClientManager<Target: RequestBuilder> {

  // The URLSession client is use to call request with URLSession Data Task Publisher
  private let clientURLSession: NetworkClientProtocol

  public init(
    clientURLSession: NetworkClientProtocol = NetworkClient()
  ) {
    self.clientURLSession = clientURLSession
  }

  func request<M, T>(
    request: Target,
    decoder: JSONDecoder = .init(),
    scheduler: T,
    responseObject type: M.Type
  ) -> AnyPublisher<M, Error> where M: Decodable, T: Scheduler {
    return clientURLSession.perform(
      with: request,
      decoder: decoder,
      scheduler: scheduler,
      responseObject: type
    )
  }
}
