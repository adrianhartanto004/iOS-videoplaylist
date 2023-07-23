import Foundation
import CoreData

@testable import VideoPlaylistExercise

class MockPersistenceStore: PersistentStore {
  let version = CoreDataStack.Version(1)
  
  lazy var container: NSPersistentContainer = {
    let container = NSPersistentContainer(name: version.modelName)
    
    let description = NSPersistentStoreDescription()
    description.url = URL(fileURLWithPath: "/dev/null")
    container.persistentStoreDescriptions = [description]
    
    container.loadPersistentStores { (description, error) in
      if let error = error {
        fatalError("Core Data Store Failed \(error.localizedDescription)")
      } else {
        print("Setup Mock Core Data success")
      }
    }

    return container
  }()
  
  var mainContext: NSManagedObjectContext {
    return self.container.viewContext
  }

  var backgroundContext: NSManagedObjectContext {
    let context = self.container.newBackgroundContext()
    context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    context.undoManager = nil

    return context
  }
}
