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
  func insertOrReplace(_ items: [Video]) -> AnyPublisher<Void, Error>
  func fetch() -> AnyPublisher<[Video], Error>
  func findByItemTaskPublisher(_ id: Int, _ title: String) ->
    AnyPublisher<VideoENT?, Never>
  func deleteAll() -> AnyPublisher<Void, Error>
}

final class VideoDaoImpl: VideoDao {
  let persistentStore: PersistentStore

  init(
    persistentStore: PersistentStore
  ) {
    self.persistentStore = persistentStore
  }

  func insertOrReplace(_ items: [Video]) -> AnyPublisher<Void, Error> {
    return Future<Void, Error> { [weak self] promise in
      guard let context = self?.persistentStore.backgroundContext else { return }
      context.configureAsUpdateContext()
      context.perform {
        do {
          printThreadName("\(#function)")
          printThread("\(#function) context.perform")
          items.forEach { item in
            if let existingVideoEnt = self?.findByItem(item.id, item.title, context) {
              existingVideoEnt.update(video: item)
              print("Update items")
            } else {
              item.store(in: context)
              print("Saving new items")
            }
          }
          if context.hasChanges == true {
            try context.save()
          }
          promise(.success(()))
        } catch {
          promise(.failure(error))
        }
      }
    }
    .receive(on: DispatchQueue.main)
    .eraseToAnyPublisher()
  }

  func fetch() -> AnyPublisher<[Video], Error> {
    return Future { [weak self] promise in
      let request: NSFetchRequest<VideoENT> = VideoENT.fetchRequest()
      request.fetchBatchSize = 10
      let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
      request.sortDescriptors = [sortDescriptor]
      guard let context = self?.persistentStore.backgroundContext else { return }
      context.perform {
        do {
          printThreadName("\(#function)")
          printThread("\(#function) context.perform")
          let managedObjects = try context.fetch(request)
          let videos = managedObjects.map { videoEnt in
            videoEnt.toVideo()
          }
          promise(.success(videos))
        } catch {
          promise(.failure(error))
        }
      }
    }
    .eraseToAnyPublisher()
  }

  private func findByItem(
    _ id: Int,
    _ title: String,
    _ context: NSManagedObjectContext
  ) -> VideoENT? {
    var output: VideoENT?
    let request: NSFetchRequest<VideoENT> = VideoENT.fetchRequest()
    let idPredicate = NSPredicate(format: "id == %@", NSNumber(value: id))
    request.predicate = idPredicate
    do {
      let managedObject = try context.fetch(request)
      printThreadName("\(#function)")
      printThread("\(#function) context.perform")
      output = managedObject.first
    } catch {
      print("findByItem error: \(error)")
    }
    return output
  }

  func findByItemTaskPublisher(_ id: Int, _ title: String) -> AnyPublisher<VideoENT?, Never> {
    return Future { [weak self] promise in
      guard let context = self?.persistentStore.mainContext else { return }
      context.perform {
        printThreadName("\(#function)")
        printThread("\(#function) context.perform")
        let videoEnt = self?.findByItem(id, title, context)
        promise(.success(videoEnt))
      }
    }
    .eraseToAnyPublisher()
  }

  func deleteAll() -> AnyPublisher<Void, Error> {
    return Future { [weak self] promise in
      let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.DBName.videoENT)
      let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
      batchDeleteRequest.resultType = .resultTypeCount
      guard let context = self?.persistentStore.backgroundContext else { return }
      context.perform {
        printThreadName("\(#function)")
        printThread("\(#function) context.perform")
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
