//
//  VideoDatabase.swift
//  VideoPlaylistExercise
//
//  Created by Adrian Hartanto on 27/06/23.
//

import Foundation
import CoreData
import Combine

protocol VideoDao {
  func insertOrReplace(_ item: Video) -> AnyPublisher<Void, Error>
  func fetch() -> AnyPublisher<[Video], Error>
  func findByItem(_ id: Int, _ title: String) -> AnyPublisher<VideoENT?, Error>
  func deleteAll() -> AnyPublisher<Void, Error>
}

final class VideoDaoImpl: VideoDao {
  let persistentStore: PersistentStore

  init(
    persistentStore: PersistentStore
  ) {
    self.persistentStore = persistentStore
  }

  func insertOrReplace(_ item: Video) -> AnyPublisher<Void, Error> {
    return findByItem(item.id, item.title)
      .flatMap { videoEnt -> AnyPublisher<Void, Error> in
        return Future<Void, Error> { [weak self] promise in
          guard let context = self?.persistentStore.mainContext else { return }
          context.configureAsUpdateContext()
          do {
            if let existingVideoEnt = videoEnt {
              existingVideoEnt.update(video: item)
            } else {
              item.store(in: context)
            }
            if context.hasChanges == true {
              try context.save()
            }
            promise(.success(()))
          } catch {
            promise(.failure(error))
          }
        }
        .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }

  func fetch() -> AnyPublisher<[Video], Error> {
    assert(Thread.isMainThread)
    return Future<[Video], Error> { [weak self] promise in
      let request: NSFetchRequest<VideoENT> = VideoENT.fetchRequest()
      var output: [Video] = []
      guard let context = self?.persistentStore.mainContext else { return }
      context.perform {
        do {
          let managedObjects = try context.fetch(request)
          let videos = managedObjects.map { videoEnt in
            videoEnt.toVideo()
          }
          output.append(contentsOf: videos)
          promise(.success(output))
        } catch {
          promise(.failure(error))
        }
      }
    }
    .eraseToAnyPublisher()
  }

  func findByItem(_ id: Int, _ title: String) -> AnyPublisher<VideoENT?, Error> {
    return Future<VideoENT?, Error> { [weak self] promise in
      var output: VideoENT?
      let request: NSFetchRequest<VideoENT> = VideoENT.fetchRequest()
      //    let idPredicate = NSPredicate(format: "id == %@", NSNumber(value: id))
      let identifier = "\(id)-\(title)"
      let idPredicate = NSPredicate(format: "identifier == %@", identifier)
      request.predicate = idPredicate
      guard let context = self?.persistentStore.mainContext else { return }
      context.perform {
        do {
          let managedObject = try context.fetch(request)
          output = managedObject.first
          promise(.success(output))
        } catch {
          promise(.failure(error))
        }
      }
    }
    .eraseToAnyPublisher()
  }

  func deleteAll() -> AnyPublisher<Void, Error> {
    return Future<Void, Error> { [weak self] promise in
      let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.DBName.videoENT)
      let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
      batchDeleteRequest.resultType = .resultTypeCount
      guard let context = self?.persistentStore.mainContext else { return }
      context.perform {
        do {
          try context.execute(batchDeleteRequest)
          promise(.success(()))
        } catch {
          promise(.failure(error))
        }
      }
    }
    .eraseToAnyPublisher()
  }
}
