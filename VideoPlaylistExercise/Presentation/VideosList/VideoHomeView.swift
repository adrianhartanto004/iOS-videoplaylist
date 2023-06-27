import SwiftUI

struct VideoHomeView: View {

  @StateObject var viewModel: VideoHomeViewModel =
    ViewModelProvider.getInstance().provideVideoHomeViewModel()

  var body: some View {
//      Group { () -> AnyView in
//        switch viewModel.uiState {
//        case .Loading(let message):
//          self.viewModel.getVideos()
//          return AnyView(Text(message))
//
//        case .Fetched(let videos):
//          return AnyView(VideoHomeContentView(videoListInfo: videos))
//
//        case .NoResultsFound:
//          return AnyView(Text("No matching movies found"))
//
//        case .ApiError(let errorMessage):
//          return AnyView(Text(errorMessage))
//        }
//      }
//    switch viewModel.videos {
//    case .notRequested:
//      notRequestedView
//    case let .isLoading(last, _):
//      loadingView(last)
//    case let .loaded(countries):
//      loadedView(countries, showLoading: false)
//    case let .failed(error):
//      failedView(error)
//    }
    Group {
      AnyView(VideoHomeContentView(videos: viewModel.videos))
    }
    .onAppear {
      viewModel.loadVideos()
      viewModel.refreshVideos()
    }
  }
}

struct ErrorView: View {
  let error: Error
  let retryAction: () -> Void

  var body: some View {
    VStack {
      Text("An Error Occured")
        .font(.title)
      Text(error.localizedDescription)
        .font(.callout)
        .multilineTextAlignment(.center)
        .padding(.bottom, 40).padding()
      Button(action: retryAction, label: { Text("Retry").bold() })
    }
  }
}

struct ActivityIndicatorView: UIViewRepresentable {

  func makeUIView(context: UIViewRepresentableContext<ActivityIndicatorView>) -> UIActivityIndicatorView {
    return UIActivityIndicatorView(style: .large)
  }

  func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicatorView>) {
    uiView.startAnimating()
  }
}
