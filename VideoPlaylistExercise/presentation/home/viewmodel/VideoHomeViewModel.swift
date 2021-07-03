import Foundation
import RxSwift

class VideoHomeViewModel : ObservableObject {

  @Published var uiState: VideoHomePageState = .Loading("Loading...")

  let disposableBag = DisposeBag()

  private let repository: VideoPlaylistRepository
  private let persistence: PersistenceHandler

  init(repository: VideoPlaylistRepository, persistence: PersistenceHandler) {
    self.repository = repository
    self.persistence = persistence
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
            self?.persistence.save(videoListInfo: response)
          }

        },
        onError: { error in
          self.persistence.load { (videoResult) in
            DispatchQueue.main.async {
              self.uiState = .Fetched(videoResult)
            }
          }
          debugPrint(error)
        }
      )
      .disposed(by: disposableBag)
  }
}

enum VideoHomePageState {
  case Loading(String)
  case Fetched(VideoListInfo)
  case NoResultsFound
  case ApiError(String)
}
