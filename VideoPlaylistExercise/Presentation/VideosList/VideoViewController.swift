//
//  VideoViewController.swift
//  VideoPlaylistExercise
//
//  Created by Adrian Hartanto on 12/09/23.
//

import Foundation
import UIKit
import Kingfisher
import Combine

class VideoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet weak var videoTableView: UITableView!
  let viewModel: VideoHomeViewModel = ViewModelProvider.getInstance().provideVideoHomeViewModel()

  private var cancellables = Set<AnyCancellable>()

  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.loadVideos()
    viewModel.refreshVideos()

    viewModel
      .$videos
      .receive(on: DispatchQueue.main)
      .sink { videos in
      self.videoTableView.reloadData()
    }
    .store(in: &cancellables)
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.videos.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let videoViewCell = tableView.dequeueReusableCell(withIdentifier: "videoViewCellID") as! VideoViewCell
    let video = viewModel.videos[indexPath.row]

    videoViewCell.videoTitle.text = video.title
    videoViewCell.videoDescription.text = video.author
    videoViewCell.videoImageView.kf.setImage(with: URL(string: video.thumbnail_url))

    return videoViewCell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
  {

    let storyBoard = UIStoryboard(name: "VideoDetail", bundle: Bundle.main)
    let videoDetailController = storyBoard.instantiateViewController(withIdentifier: "VideoDetailController") as! VideoDetailController
    videoDetailController.video = viewModel.videos[indexPath.row]
    self.navigationController?.pushViewController(videoDetailController, animated: true)
  }
}
