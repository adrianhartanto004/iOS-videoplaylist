import AVKit
import SwiftUI

struct VideoDetailView: View {
  let videoInfo: Video
  var avPlayer: AVPlayer?

  init(videoInfo: Video) {
    self.videoInfo = videoInfo
    guard let videoUrl = URL(string: videoInfo.video_url) else { return }
    avPlayer = AVPlayer(url: videoUrl)
  }

  var body: some View {
    ScrollView{
      VStack(alignment: .leading){
        VideoPlayer(player: avPlayer).frame(height: UIScreen.main.bounds.height / 3)
        VStack(alignment: .leading){
          Text(videoInfo.title)
            .font(.title)
            .foregroundColor(Color("general_text"))
          Text(videoInfo.author)
            .font(.subheadline)
            .foregroundColor(.secondary)
          Divider()
          Text(videoInfo.description)
            .font(.title2)
            .foregroundColor(Color("general_text"))
        }
      }
      .padding()
      .onAppear{
        avPlayer?.seek(to: .zero)
      }
      .onDisappear{
        avPlayer?.pause()
      }
    }
    .navigationBarTitle(videoInfo.title)
    .navigationBarTitleDisplayMode(.inline)
  }
}

struct VideoDetailView_Previews: PreviewProvider {
  static var previews: some View {
    VideoDetailView(videoInfo: Video.videoInfoMockData.first!)
  }
}
