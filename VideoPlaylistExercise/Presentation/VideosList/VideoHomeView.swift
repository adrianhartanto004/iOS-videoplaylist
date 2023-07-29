import SwiftUI

struct VideoHomeView: View {
  @StateObject var viewModel: VideoHomeViewModel =
    ViewModelProvider.getInstance().provideVideoHomeViewModel()

  var body: some View {
    VStack {
      if viewModel.isLoading && viewModel.videos.isEmpty {
        ActivityIndicatorView()
      } else if !viewModel.videos.isEmpty {
        VideoHomeContentView(videos: viewModel.videos)
      } else if viewModel.error != nil {
        ErrorView(error: viewModel.error) {
          viewModel.loadVideos()
          viewModel.refreshVideos()
        }
      }
    }
    .onAppear {
      viewModel.loadVideos()
      viewModel.refreshVideos()
    }
    .navigationTitle("Playlist")
    .navigationBarTitleDisplayMode(.inline)
  }
}

struct ErrorView: View {
  let error: Error?
  let retryAction: () -> Void

  var body: some View {
    VStack {
      Text("An Error Occured")
        .font(.title)
      Text(error?.localizedDescription ?? "")
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

struct VideoHomeView_Previews: PreviewProvider {
  static var previews: some View {
    VideoHomeView()
  }
}
