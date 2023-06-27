import Foundation
import CoreData

struct Video: Hashable, Codable {
  var id: Int
  var description: String
  var video_url: String
  var author: String
  var thumbnail_url: String
  var title: String

  enum CodingKeys: String, CodingKey {
    case id = "id"
    case description = "description"
    case video_url = "video_url"
    case author = "author"
    case thumbnail_url = "thumbnail_url"
    case title = "title"
  }
}

extension Video: Equatable {
  static func == (lhs: Video, rhs: Video) -> Bool {
    return lhs.id == rhs.id
  }
}

extension VideoENT {
  func update(video: Video) -> VideoENT {
    self.identifier = "\(video.id)-\(video.title)"
    self.id = Int32(video.id)
    self.desc = video.description
    self.videoUrl = video.video_url
    self.author = video.author
    self.thumbnailUrl = video.thumbnail_url
    self.title = video.title
    return self
  }

  func toVideo() -> Video {
    return Video(
      id: Int(self.id),
      description: self.desc ?? "",
      video_url: self.videoUrl ?? "",
      author: self.author ?? "",
      thumbnail_url: self.thumbnailUrl ?? "",
      title: self.title ?? ""
    )
  }
}

extension Video {
  @discardableResult
  func store(in context: NSManagedObjectContext) -> VideoENT? {
    guard let videoEnt = VideoENT.insertNew(in: context)
      else { return nil }
    videoEnt.identifier = "\(id)-\(title)"
    videoEnt.id = Int32(id)
    videoEnt.desc = description
    videoEnt.videoUrl = video_url
    videoEnt.author = author
    videoEnt.thumbnailUrl = thumbnail_url
    videoEnt.title = title
    return videoEnt
  }

  static let videoInfoMockData: [Video] = [
    Video(
      id: 0,
      description: "Big Buck Bunny tells the story of a giant rabbit with a heart bigger than himself. When one sunny day three rodents rudely harass him, something snaps... and the rabbit ain't no bunny anymore! In the typical cartoon tradition he prepares the nasty rodents a comical revenge.\n\nLicensed under the Creative Commons Attribution license",
      video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
      author: "By Blender Foundation",
      thumbnail_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg",
      title: "Big Buck Bunny"
    ),
    Video(
      id: 1,
      description: "The first Blender Open Movie from 2006",
      video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
      author: "By Blender Foundation",
      thumbnail_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ElephantsDream.jpg",
      title: "Elephant Dream"
    ),
    Video(
      id: 2,
      description: "HBO GO now works with Chromecast -- the easiest way to enjoy online video on your TV. For when you want to settle into your Iron Throne to watch the latest episodes. For $35.\nLearn how to use Chromecast with HBO GO and more at google.com/chromecast.",
      video_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
      author: "By Google",
      thumbnail_url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerBlazes.jpg",
      title: "For Bigger Blazes"
    )
   ]
}

extension VideoENT: ManagedEntity {}
