import Foundation
import RxSwift

protocol VideoPlaylistRepository {
  func getVideoList() -> Observable<VideoListInfo>
}
