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
      .receive(on: DispatchQueue.main)
      .sink { [weak self] result in
        switch result {
        case .finished:
          print("finished fetching")
          self?.loadVideos()
        case .failure(let error):
          print("ErrorNya: \(error)")
        }
      } receiveValue: { _ in
      }
      .store(in: &cancellables)
  }

  func loadVideos() {
    self.getVideoUsecase.execute()
      .receive(on: DispatchQueue.main)
      .removeDuplicates()
      .sink { [weak self] _ in
      } receiveValue: { [weak self] videos in
        self?.videos = videos
      }
      .store(in: &self.cancellables)
  }
}
