import Foundation
import RxSwift

class VideoHomeViewModel : ObservableObject {

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

  @Published var uiState: VideoHomePageState = .Loading("Loading...")

  let disposableBag = DisposeBag()

  private let repository: VideoPlaylistRepository

  init(repository: VideoPlaylistRepository) {
    self.repository = repository
  }

  func getVideos() {
    repository
      .getVideoList()
      .subscribe(
        onNext: { [weak self] response in
          debugPrint(response)

          if response.play_list.count == 0 {
            self?.uiState = .NoResultsFound
          } else {
            self?.uiState = .Fetched(response)
            self?.save(videoListInfo: response)
          }

        },
        onError: { error in
          self.load()
          debugPrint(error)
        }
      )
      .disposed(by: disposableBag)
  }

    private func load() {
      DispatchQueue.global(qos: .background).async { [weak self] in
        guard let data = try? Data(contentsOf: Self.fileURL) else {
          #if DEBUG
          DispatchQueue.main.async {
            self?.uiState = .Fetched(VideoListInfo.videoListInfoMockData)
          }
          #endif
          return
        }
        guard let videoList = try? JSONDecoder().decode(VideoListInfo.self, from: data) else {
          fatalError("Can't decode saved playlist data.")
        }
        DispatchQueue.main.async {
          self?.uiState = .Fetched(videoList)
        }
      }
    }

  private func save(videoListInfo: VideoListInfo) {
    DispatchQueue.global(qos: .background).async {
//      guard let videos = videoListInfo else { fatalError("Self out of scope") }
      guard let data = try? JSONEncoder().encode(videoListInfo) else { fatalError("Error encoding data") }
      do {
        let outfile = Self.fileURL
        try data.write(to: outfile)
      } catch{
        fatalError("Can't write to file")
      }
    }
  }
}

enum VideoHomePageState {
  case Loading(String)
  case Fetched(VideoListInfo)
  case NoResultsFound
  case ApiError(String)
}
