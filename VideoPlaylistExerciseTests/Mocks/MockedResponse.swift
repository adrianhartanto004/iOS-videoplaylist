//
//  MockedResponse.swift
//  VideoPlaylistExerciseTests
//
//  Created by Adrian Hartanto on 20/07/23.
//

import Foundation
@testable import VideoPlaylistExercise

extension RequestMocking {
  struct MockedResponse {
    let url: URL
    let result: Result<Data, Swift.Error>
    let httpCode: Int
    let headers: [String: String]
    let loadingTime: TimeInterval
    let customResponse: URLResponse?
  }
}

extension RequestMocking.MockedResponse {
  enum Error: Swift.Error {
    case failedMockCreation
  }

  init(
    request: RequestBuilder,
    result: Result<Data, Swift.Error>,
    headers: [String: String] = ["Content-Type": "application/json"],
    httpCode: Int = 200
  ) throws {
    guard let url = request.buildURLRequest().url
    else { throw Error.failedMockCreation }
    self.url = url
    switch result {
    case let .success(value):
      self.result = .success(value)
    case let .failure(error):
      self.result = .failure(error)
    }
    self.httpCode = httpCode
    self.headers = request.headers ?? headers
    loadingTime = 0
    self.customResponse = nil
  }
}
