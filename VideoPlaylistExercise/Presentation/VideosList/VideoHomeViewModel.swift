import Combine
import Foundation

class VideoHomeViewModel : ObservableObject {
  @Published var videos: [Video] = []

  private var cancellables = Set<AnyCancellable>()

  private let fetchVideoUsecase: FetchVideoUsecase
  private let getVideoUsecase: GetVideoUsecase

  init(
    _ fetchVideoUsecase: FetchVideoUsecase,
    _ getVideoUsecase: GetVideoUsecase
  ) {
    self.fetchVideoUsecase = fetchVideoUsecase
    self.getVideoUsecase = getVideoUsecase
  }

  deinit {
    print("deInit has been called")
    cancellables.removeAll()
  }

  func refreshVideos() {
    fetchVideoUsecase.execute()
      .flatMap { [weak self] _ -> AnyPublisher<[Video], Error> in
        guard let self = self else {
          return Fail.init(
            error: NSError(
              domain: "VideoHomeViewModel", code: 0, userInfo: ["message": "nil self"])
          )
          .eraseToAnyPublisher()
        }
        return self.getVideoUsecase.execute()
      }
      .receive(on: DispatchQueue.main)
      .sink { completion in
        switch completion {
        case .finished:
          print("Refresh videos finished")
        case .failure(let error):
          print("Error: \(error)")
        }
      } receiveValue: { videos in
        self.videos = videos
      }
      .store(in: &cancellables)
  }

  func loadVideos() {
    self.getVideoUsecase.execute()
      .receive(on: DispatchQueue.main)
      .removeDuplicates()
      .sink { completion in
        switch completion {
        case .finished:
          print("loadVideos videos finished")
        case .failure(let error):
          print("Error: \(error)")
        }
      } receiveValue: { [weak self] videos in
        self?.videos = videos
      }
      .store(in: &self.cancellables)
  }
}
