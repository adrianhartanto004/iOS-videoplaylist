import AVKit
import SwiftUI

struct VideoDetailView: View {
  @Environment(\.colorScheme) private var colorScheme

  let videoInfo: VideoInfo
  var avPlayer: AVPlayer?

  init(videoInfo: VideoInfo){
    self.videoInfo = videoInfo
    avPlayer = AVPlayer(url: URL(string: videoInfo.video_url)!)
  }

  var body: some View {
    ScrollView{
      VStack(alignment: .leading){
        VideoPlayer(player: avPlayer).frame(height: UIScreen.main.bounds.height / 3)
        VStack(alignment: .leading){
          Text(videoInfo.title)
            .font(.title)
            .foregroundColor(colorScheme == .dark ? .white : .black)

          Text(videoInfo.author)
            .font(.subheadline)
            .foregroundColor(.secondary)

          Divider()

          Text(videoInfo.description)
            .font(.title2)
            .foregroundColor(colorScheme == .dark ? .white : .black)
        }
      }
      .padding()
      .onAppear{
        avPlayer?.play()
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
  static let videoInfo = VideoInfo(id: 1, description: "The first Blender Open Movie from 2006", video_url: "video_url", author: "By Blender Foundation", thumbnail_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ElephantsDream.jpg", title: "Elephant Dream")
  static var previews: some View {
    VideoDetailView(videoInfo: videoInfo)
  }
}
