//
//  VideoService.swift
//  VideoPlaylistExercise
//
//  Created by Adrian Hartanto on 27/06/23.
//

import Foundation
import Combine

protocol VideoService: AnyObject {
  func fetch() -> AnyPublisher<VideoListInfo?, Error>
}

final class VideoServiceImpl: NetworkClientManager<HttpRequest>, VideoService {
  func fetch() -> AnyPublisher<VideoListInfo?, Error> {
    self.request(
      request: HttpRequest(request: VideoRequest()),
      scheduler: DispatchQueue.main,
      responseObject: VideoListInfo?.self
    )
  }
}

struct VideoRequest: NetworkTarget {
  var baseURL: BaseURLType {
    return .baseApi
  }

  var version: VersionType {
    return .none
  }

  var path: String? {
    return "/adrianhartanto004/ef1cfab2cb0ccb9258dcde7afbb8543e/raw/"
  }

  var methodType: HTTPMethod {
    .get
  }

  var queryParamsEncoding: URLEncoding? {
    return .default
  }
}
