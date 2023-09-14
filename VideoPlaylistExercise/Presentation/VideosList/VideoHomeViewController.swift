//
//  VideoHomeViewController.swift
//  VideoPlaylistExercise
//
//  Created by Adrian Hartanto on 12/09/23.
//

import Foundation
import UIKit
import Kingfisher
import Combine

class VideoHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, Storyboarded {

  @IBOutlet weak var videoTableView: UITableView!
  let viewModel: VideoHomeViewModel = ViewModelProvider.getInstance().provideVideoHomeViewModel()

  private var cancellables = Set<AnyCancellable>()

  weak var coordinator: VideoCoordinator?

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

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    coordinator?.goToDetailScreen(viewModel.videos[indexPath.row])
  }
}
