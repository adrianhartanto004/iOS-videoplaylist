import SwiftUI
import Kingfisher

struct VideoHomeContentsView: View {

  let videoListInfo: VideoListInfo

  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack {
        ForEach(videoListInfo.play_list, id: \.self) { videoInfo in
          VideoHomeContentView(videoInfo: videoInfo)
        }
      }
    }
    .padding()
  }
}

struct VideoHomeContentView: View {

  let videoInfo: VideoInfo

  var body: some View {
    HStack {
      KFImage(URL(string: videoInfo.thumbnail_url))
        .resizable()
        .frame(width: 150, height: 150)
        .cornerRadius(20)
      VStack {
        HStack {
          Text(videoInfo.title)
            .frame(alignment: Alignment.topLeading)
            .foregroundColor(.black)
            .font(.subheadline)
          Spacer()
        }
        Spacer()
        HStack{
          Text(videoInfo.description)
            .frame(alignment: Alignment.topLeading)
            .foregroundColor(.gray)
            .lineLimit(3)

          Spacer()
        }
      }
      .padding()
    }
  }
}

struct VideoHomeContentsView_Previews: PreviewProvider {
  static let videoInfo = VideoInfo(id: 1, description: "The first Blender Open Movie from 2006", video_url: "video_url", author: "By Blender Foundation", thumbnail_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ElephantsDream.jpg", title: "Elephant Dream")
  static let videoListInfo = VideoListInfo(play_list: [videoInfo])
  static var previews: some View {
    VideoHomeContentsView(videoListInfo: videoListInfo)
  }
}
