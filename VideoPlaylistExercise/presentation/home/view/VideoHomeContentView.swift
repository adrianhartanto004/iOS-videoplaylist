import SwiftUI
import Kingfisher

struct VideoHomeContentView: View {

  let videoListInfo: VideoListInfo

  var body: some View {
    NavigationView {
      List {
        ForEach(videoListInfo.play_list, id: \.self) { videoInfo in
          NavigationLink(destination: VideoDetailView(videoInfo: videoInfo)){
            VideoHomeRowView(videoInfo: videoInfo)
          }
        }
      }
      .navigationTitle("Playlist")
    }
  }
}

struct VideoHomeRowView: View {
  @Environment(\.colorScheme) private var colorScheme
  let videoInfo: VideoInfo

  var body: some View {
    HStack {
      KFImage(URL(string: videoInfo.thumbnail_url))
        .resizable()
        .frame(width: 150, height: 150)
        .cornerRadius(16)
      VStack {
        HStack {
          Text(videoInfo.title)
            .frame(alignment: Alignment.topLeading)
            .foregroundColor(colorScheme == .dark ? .white : .black)
            .font(.headline)
            .lineLimit(3)
          Spacer()
        }
        Spacer()
        HStack{
          Text(videoInfo.author)
            .frame(alignment: Alignment.topLeading)
            .foregroundColor(.gray)
            .lineLimit(3)
            .font(.subheadline)

          Spacer()
        }
      }
      .padding()
    }
  }
}

struct VideoHomeContentsView_Previews: PreviewProvider {
  static var previews: some View {
    VideoHomeContentView(videoListInfo: VideoListInfo.videoListInfoMockData)
  }
}
