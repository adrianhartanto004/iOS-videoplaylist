import Foundation

enum APIError: Swift.Error {
  case general
  case timeout
  case pageNotFound
  case noData
  case noNetwork
  case unknownError
  case serverError
  case redirection
  case clientError
  case invalidResponse(httpStatusCode: Int)
  case statusMessage(message: String)
  case decodingError(Error)
  case connectionError(Error)
  case unauthorizedClient
  case urlError(URLError)
  case httpError(HTTPURLResponse)
  case type(Error)
}

extension APIError: LocalizedError {
  var desc: String {
    switch self {
    case .general:
      return "Bad Request"
    case .timeout:
      return "Timeout"
    case .pageNotFound:
      return "Page not found"
    case .noData:
      return "No Result"
    case .noNetwork:
      return "Check internet connection"
    case .unknownError:
      return "Unknown Error"
    case .serverError:
      return "Internal Server Error"
    case .redirection:
      return "Request doesn't seem to be proper."
    case .clientError:
      return "Request doesn't seem to be proper."
    case .invalidResponse:
      return "Invalid Server Response"
    case .unauthorizedClient:
      return "Unauthorized Client"
    case .statusMessage(let message):
      return message
    case .decodingError(let error):
      return "Decoding Error: \(error.localizedDescription)"
    case .connectionError(let error):
      return "Network connection Error : \(error.localizedDescription)"
    default:
      return "Bad Request"
    }
  }
}

extension NetworkClient {
  static func errorType(type: Int) -> APIError {
    switch type {
    case 300..<400:
      return APIError.redirection
    case 400..<500:
      return APIError.clientError
    case 500..<600:
      return APIError.serverError
    default:
      return otherErrorType(type: type)
    }
  }
  private static func otherErrorType(type: Int) -> APIError {
    switch type {
    case -1001:
      return APIError.timeout
    case -1009:
      return APIError.noNetwork
    default:
      return APIError.unknownError
    }
  }
}
