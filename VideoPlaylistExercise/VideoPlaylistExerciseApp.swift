//
//  VideoPlaylistExerciseApp.swift
//  VideoPlaylistExercise
//
//  Created by Adrian Hartanto on 02/07/21.
//

import SwiftUI

@main
struct VideoPlaylistExerciseApp: App {
  let repository = VideoPlaylistRepositoryImpl()
    var body: some Scene {
        WindowGroup {
            VideoHomeView(viewModel: VideoHomeViewModel(repository: repository))
        }
    }
}
