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
