import Foundation
import Alamofire
import RxSwift

class VideoPlaylistRepositoryImpl : VideoPlaylistRepository {

  private func createRequest<T: Codable>(url: String) -> Observable<T> {

    let observable = Observable<T>.create { observer -> Disposable in

      AF.request(url)
        .validate()
        .responseJSON { response in
          switch response.result {
          case .success:
            guard let data = response.data else {
              observer.onError(response.error ?? MyError.runtimeError("random message"))
              return
            }
            do {
              let projects = try JSONDecoder().decode(T.self, from: data)
              observer.onNext(projects)
            } catch {
              observer.onError(error)
            }
          case .failure(let error):
            observer.onError(error)
          }
        }
      return Disposables.create()
    }
//    observable.observe(on: MainScheduler.instance)

    return observable
  }

  func getVideoList() -> Observable<VideoListInfo> {
    return createRequest(url: "https://gist.githubusercontent.com/ayinozendy/a1f7629d8760c0d9cd4a5a4f051d111c/raw/6ead19b28382af688e8b4426d2310f0468a2fb5f/playlist.json")
  }
}
