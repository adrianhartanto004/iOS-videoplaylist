import SwiftUI
import Kingfisher

struct VideoHomeContentView: View {

  let videos: [Video]

  var body: some View {
    NavigationView {
      List {
        ForEach(videos, id: \.self) { video in
          NavigationLink(
            destination: VideoDetailView(videoInfo: video)
          ) {
            VideoHomeRowView(video: video)
          }
        }
      }
      .navigationTitle("Playlist")
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

struct VideoHomeRowView: View {
  @Environment(\.colorScheme) private var colorScheme
  let video: Video

  var body: some View {
    HStack {
      KFImage(URL(string: video.thumbnail_url))
        .resizable()
        .frame(width: 150, height: 150)
        .cornerRadius(16)
      VStack {
        HStack {
          Text(video.title)
            .frame(alignment: Alignment.topLeading)
            .foregroundColor(colorScheme == .dark ? .white : .black)
            .font(.headline)
            .lineLimit(3)
          Spacer()
        }
        Spacer()
        HStack{
          Text(video.author)
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

//struct VideoHomeContentsView_Previews: PreviewProvider {
//  static var previews: some View {
//    VideoHomeContentView(videoListInfo: VideoListInfo.videoListInfoMockData)
//  }
//}
