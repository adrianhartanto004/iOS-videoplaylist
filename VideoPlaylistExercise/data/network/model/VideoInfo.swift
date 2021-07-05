import SwiftUI
import Foundation

struct VideoInfo : Codable, Identifiable, Hashable {
  let id : Int
  let description : String
  let video_url : String
  let author : String
  let thumbnail_url : String
  let title : String
}

extension VideoInfo {

  init(videoEntity: VideoEntity) {
    id = videoEntity.id
    description = videoEntity.title
    video_url = videoEntity.video_url
    author = videoEntity.author
    thumbnail_url = videoEntity.thumbnail_url
    title = videoEntity.title
  }

  static let videoInfoMockData = VideoInfo(id: 1, description: "The first Blender Open Movie from 2006", video_url: "video_url", author: "By Blender Foundation", thumbnail_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ElephantsDream.jpg", title: "Elephant Dream")
}
