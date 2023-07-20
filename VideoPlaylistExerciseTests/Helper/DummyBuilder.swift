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

func createVideo() -> Video {
  return Video(
    id: Int.random(in: 1...100),
    description: randomString(2),
    video_url: randomString(2),
    author: randomString(2),
    thumbnail_url: randomString(2),
    title: randomString(2)
  )
}
