import Combine
import Foundation

class VideoHomeViewModel {
  @Published var isLoading = false
  @Published var videos: [Video] = []
  @Published var error: Error?

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
    error = nil
    isLoading = true
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
      .sink { [weak self] completion in
        switch completion {
        case .finished:
          self?.isLoading = false
        case .failure(let error):
          self?.error = error
          self?.isLoading = false
          print("error: \(error.localizedDescription)")
        }
      } receiveValue: { [weak self] videos in
        self?.videos = videos
        printThreadName("\(#function)")
        printThread("\(#function) sink")
      }
      .store(in: &cancellables)
  }

  func loadVideos() {
    error = nil
    isLoading = true
    getVideoUsecase.execute()
      .receive(on: DispatchQueue.main)
      .removeDuplicates()
      .sink { [weak self] completion in
        switch completion {
        case .finished:
          break
        case .failure(let error):
          self?.error = error
          self?.isLoading = false
        }
      } receiveValue: { [weak self] videos in
        printThreadName("\(#function)")
        printThread("\(#function) sink")
        self?.videos = videos
      }
      .store(in: &self.cancellables)
  }
}
