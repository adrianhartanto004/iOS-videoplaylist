import SwiftUI

@main
struct VideoPlaylistExerciseApp: App {
  let repository = VideoPlaylistRepositoryImpl()
  var body: some Scene {
    WindowGroup {
      VideoHomeView(viewModel: VideoHomeViewModel(repository: repository))
    }
  }
}
