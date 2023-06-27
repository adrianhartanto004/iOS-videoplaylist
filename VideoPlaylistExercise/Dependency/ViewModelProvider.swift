//
//  ViewModelProvider.swift
//  VideoPlaylistExercise
//
//  Created by Adrian Hartanto on 26/06/23.
//

import Foundation

class ViewModelProvider {
  private static let instance = ViewModelProvider()

  static func getInstance() -> ViewModelProvider {
    return instance
  }

  func provideVideoHomeViewModel() -> VideoHomeViewModel {
    let fetchVideoUsecase = UsecaseProvider.getInstance().provideFetchVideoUsecase()
    let getVideoUsecase = UsecaseProvider.getInstance().provideGetVideoUsecase()
    return VideoHomeViewModel(fetchVideoUsecase, getVideoUsecase)
  }
}
