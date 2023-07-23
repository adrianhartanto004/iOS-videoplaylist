import Foundation

@testable import VideoPlaylistExercise

func createVideoListInfo() -> VideoListInfo {
  return VideoListInfo(
    play_list: [
      createVideo(),
      createVideo(),
      createVideo()
    ]
  )
}

func createVideo(
  id: Int = Int.random(in: 1...100),
  title: String = randomString(2),
  description: String = randomString(2)
) -> Video {
  return Video(
    id: id,
    description: description,
    video_url: randomString(2),
    author: randomString(2),
    thumbnail_url: randomString(2),
    title: title
  )
}
