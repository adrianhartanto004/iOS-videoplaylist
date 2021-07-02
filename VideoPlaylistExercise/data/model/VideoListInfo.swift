import SwiftUI
import Foundation

struct VideoListInfo : Codable {
  let play_list : [VideoInfo]
}

enum MyError: Error{
  case runtimeError(String)
}

extension VideoListInfo {
  static let videoListInfoMockData = VideoListInfo(play_list: [VideoInfo.videoInfoMockData])
}
