import Foundation

protocol PersistenceHandler {
  func load(completion: @escaping (VideoListInfo) -> ())
  func save(videoListInfo: VideoListInfo)
}
