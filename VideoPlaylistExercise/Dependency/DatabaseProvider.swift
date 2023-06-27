//
//  DatabaseProvider.swift
//  VideoPlaylistExercise
//
//  Created by Adrian Hartanto on 26/06/23.
//

import Foundation

class DatabaseProvider {
  private static let instance = DatabaseProvider()

  static func getInstance() -> DatabaseProvider {
    return instance
  }

  let coreDataStack = CoreDataStack(version: CoreDataStack.Version.actual)

  func provideVideoDao() -> VideoDao {
    return VideoDaoImpl(persistentStore: coreDataStack)
  }
}
