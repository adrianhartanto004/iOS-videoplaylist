import Foundation
import RealmSwift

class VideoEntity: Object {

  @objc dynamic var id : Int = 0
  @objc dynamic var desc = ""
  @objc dynamic var video_url = ""
  @objc dynamic var author = ""
  @objc dynamic var thumbnail_url = ""
  @objc dynamic var title = ""

  override static func primaryKey() -> String? {
    "id"
  }
}
