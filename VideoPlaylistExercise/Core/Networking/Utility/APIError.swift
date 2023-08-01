import Foundation

enum APIError: Swift.Error {
  case general
  case timeout
  case noNetwork
  case unknownError
  case serverError
  case redirection
  case clientError
  case unexpectedResponse
  case statusMessage(message: String)
  case httpCode(_ code: Int)
}

extension APIError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .general:
      return "Bad Request"
    case .timeout:
      return "Timeout"
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
    case .unexpectedResponse:
      return "Unexpected Server Response"
    case .statusMessage(let message):
      return message
    case .httpCode(let code):
      return errorType(code).errorDescription
    }
  }
}

extension APIError {
  func errorType(_ type: Int) -> APIError {
    switch type {
    case 300..<400:
      return APIError.redirection
    case 400..<500:
      return APIError.clientError
    case 500..<600:
      return APIError.serverError
    case -1001:
      return APIError.timeout
    case -1009:
      return APIError.noNetwork
    default:
      return APIError.unknownError
    }
  }
}
