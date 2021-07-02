import AVKit
import SwiftUI

struct VideoDetailView: View {
  let videoInfo: VideoInfo

  init(videoInfo: VideoInfo){
    self.videoInfo = videoInfo
  }

  var body: some View {
    ScrollView{
      VStack(alignment: .leading){
        VideoPlayer(player: AVPlayer(url: URL(string: videoInfo.video_url)!)).frame(height: UIScreen.main.bounds.height / 3)
        VStack(alignment: .leading){
          Text(videoInfo.title)
            .font(.title)
            .foregroundColor(.black)

          Text(videoInfo.author)
            .font(.subheadline)
            .foregroundColor(.secondary)

          Divider()

          Text(videoInfo.description)
            .font(.title2)
            .foregroundColor(.black)
        }
      }
      .padding()
      .onDisappear{
        
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
