import Foundation

struct VideoListInfo: Codable {
  var play_list : [Video]
}

extension VideoListInfo: Equatable {
  static func == (lhs: VideoListInfo, rhs: VideoListInfo) -> Bool {
    return lhs.play_list == rhs.play_list
  }
}

extension VideoListInfo {
  static let videoListInfoMockData = VideoListInfo(play_list: Video.videoInfoMockData)
}
