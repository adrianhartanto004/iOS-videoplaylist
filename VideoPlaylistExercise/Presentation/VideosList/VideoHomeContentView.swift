import SwiftUI
import Kingfisher

struct VideoHomeContentView: View {
  let videos: [Video]

  var body: some View {
    List {
      ForEach(videos, id: \.self) { video in
        NavigationLink(
          destination: VideoDetailView(videoInfo: video)
        ) {
          VStack {
            HStack {
              KFImage(URL(string: video.thumbnail_url))
                .resizable()
                .frame(width: 150, height: 150)
                .cornerRadius(16)
              VStack(alignment: .leading) {
                Text(video.title)
                  .foregroundColor(Color("general_text"))
                  .font(.headline)
                  .lineLimit(2)
                Spacer()
                Text(video.author)
                  .foregroundColor(.gray)
                  .lineLimit(2)
                  .font(.subheadline)
                  .padding(.top, 8)
              }
              .padding()
            }
          }
        }
      }
    }
  }
}

struct VideoHomeContentsView_Previews: PreviewProvider {
  static var previews: some View {
    VideoHomeContentView(
      videos: Video.videoInfoMockData
    )
  }
}
