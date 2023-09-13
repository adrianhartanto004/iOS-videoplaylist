//
//  VideoDetailController.swift
//  VideoPlaylistExercise
//
//  Created by Adrian Hartanto on 13/09/23.
//

import Foundation
import UIKit
import AVKit

class VideoDetailController: UIViewController {
  @IBOutlet weak var videoView: UIView!
  @IBOutlet weak var videoTitle: UILabel!
  @IBOutlet weak var videoAuthor: UILabel!
  @IBOutlet weak var videoDescription: UILabel!
  
  var video: Video!
  var player: AVPlayer?
  var playerController = AVPlayerViewController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    startVideo()
    setLabels()
  }

  func startVideo() {
    guard let videoUrl = URL(string: video.video_url) else { return }
    player = AVPlayer(url: videoUrl)
    playerController.player = player
    playerController.view.frame = self.videoView.bounds
    self.addChild(playerController)
    self.videoView.addSubview(playerController.view)
    player?.play()
  }

  func setLabels() {
    videoTitle.text = video.title
    videoAuthor.text = video.author
    videoDescription.text = video.description
  }
}
