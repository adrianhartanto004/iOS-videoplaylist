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
  static let videoInfoMockData = VideoInfo(id: 1, description: "The first Blender Open Movie from 2006", video_url: "video_url", author: "By Blender Foundation", thumbnail_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ElephantsDream.jpg", title: "Elephant Dream")
}
