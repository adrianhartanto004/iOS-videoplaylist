import Foundation
import RxSwift

class VideoHomeViewModel : ObservableObject {

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
          }

        },
        onError: { error in
          self.uiState = .ApiError("Results couldnot be fetched")
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
