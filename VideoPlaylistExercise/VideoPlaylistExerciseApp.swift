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
  let persistenceHandler = PersistenceHandlerImpl()
    var body: some Scene {
        WindowGroup {
            VideoHomeView(viewModel: VideoHomeViewModel(repository: repository, persistence: persistenceHandler))
        }
    }
}
