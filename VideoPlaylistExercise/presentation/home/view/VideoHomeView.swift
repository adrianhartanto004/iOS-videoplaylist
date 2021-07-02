import SwiftUI

struct VideoHomeView: View {

  @ObservedObject var viewModel: VideoHomeViewModel

  init(viewModel: VideoHomeViewModel) {
    self.viewModel = viewModel
  }

  var body: some View {
    ScrollView {
      Group { () -> AnyView in

        switch viewModel.uiState {
        case .Loading(let message):
          self.viewModel.getVideos()
          return AnyView(Text(message))

        case .Fetched(let videos):
          return AnyView(VideoHomeContentsView(videoListInfo: videos))

        case .NoResultsFound:
          return AnyView(Text("No matching movies found"))

        case .ApiError(let errorMessage):
          return AnyView(Text(errorMessage))
        }
      }
    }
  }
}

//struct VideoHomeView_Previews: PreviewProvider {
//  static let repository = VideoPlaylistRepositoryImpl()
//  static var previews: some View {
//    VideoHomeView(viewModel: VideoHomeViewModel(repository: repository))
//  }
//}
