import Foundation
import RxSwift
import RealmSwift

class VideoHomeViewModel : ObservableObject {

  private var videoRealmResults: Results<VideoEntity>

  @Published var uiState: VideoHomePageState = .Loading("Loading...")

  let disposableBag = DisposeBag()

  private let repository: VideoPlaylistRepository

  let realm = try! Realm()
  
  init(repository: VideoPlaylistRepository) {
    self.repository = repository
    videoRealmResults = realm.objects(VideoEntity.self)
  }

  var videoLocal: [VideoInfo] {
    videoRealmResults.map(VideoInfo.init)
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
            for item in response.play_list {
              self?.create(id: item.id, desc: item.description, video_url: item.video_url, author: item.author, thumbnail_url: item.thumbnail_url, title: item.title)
            }
//            self?.persistence.save(videoListInfo: response)
          }

        },
        onError: { error in
          let videoListInfo = VideoListInfo(play_list: self.videoLocal)
//          self.persistence.load { (videoList) in
            self.uiState = .Fetched(videoListInfo)
//          }
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

// MARK: - CRUD Actions
extension VideoHomeViewModel {
  func create(id: Int, desc: String, video_url: String, author: String, thumbnail_url: String, title: String) {
    objectWillChange.send()

    do {
      let realm = try Realm()

      let videoEntity = VideoEntity()
      videoEntity.id = id
      videoEntity.desc = desc
      videoEntity.video_url = video_url
      videoEntity.author = author
      videoEntity.thumbnail_url = thumbnail_url
      videoEntity.title = title

      try realm.write {
        realm.add(videoEntity, update: .all)
      }
    } catch let error {
      // Handle error
      print(error.localizedDescription)
    }
  }
}
