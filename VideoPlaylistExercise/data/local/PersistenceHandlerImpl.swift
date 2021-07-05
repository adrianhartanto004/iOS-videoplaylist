import Foundation

class PersistenceHandlerImpl : PersistenceHandler{

  private static var documentsFolder: URL {
    do {
      return try FileManager.default.url(for: .documentDirectory,
                                         in: .userDomainMask,
                                         appropriateFor: nil,
                                         create: false)
    } catch {
      fatalError("Can't find documents directory.")
    }
  }
  private static var fileURL: URL {
    return documentsFolder.appendingPathComponent("playlist.data")
  }

  func load(completion: @escaping (VideoListInfo) -> ()) {
    DispatchQueue.global(qos: .background).async {
      guard let data = try? Data(contentsOf: Self.fileURL) else {
        fatalError()
      }

      guard let videoList = try? JSONDecoder().decode(VideoListInfo.self, from: data) else {
        fatalError("Can't decode saved playlist data.")
      }

      DispatchQueue.main.async {
        completion(videoList as VideoListInfo)
      }
    }
  }

  func save(videoListInfo: VideoListInfo) {
    DispatchQueue.global(qos: .background).async {
      //      guard let videos = videoListInfo else { fatalError("Self out of scope") }
      guard let data = try? JSONEncoder().encode(videoListInfo) else { fatalError("Error encoding data") }
      do {
        let outFile = Self.fileURL
        try data.write(to: outFile)
      } catch{
        fatalError("Can't write to file")
      }
    }
  }
}
