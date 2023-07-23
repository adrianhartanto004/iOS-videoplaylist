import CoreData
import Combine

protocol PersistentStore {
  var container: NSPersistentContainer { get }
  var mainContext: NSManagedObjectContext { get }
  var backgroundContext: NSManagedObjectContext { get }
}

class CoreDataStack: PersistentStore {
  let container: NSPersistentContainer

  var mainContext: NSManagedObjectContext {
    return self.container.viewContext
  }

  var backgroundContext: NSManagedObjectContext {
    let context = self.container.newBackgroundContext()
    context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    context.undoManager = nil

    return context
  }

  init(
    directory: FileManager.SearchPathDirectory = .documentDirectory,
    domainMask: FileManager.SearchPathDomainMask = .userDomainMask,
    version vNumber: UInt
  ) {
    let version = Version(vNumber)
    container = NSPersistentContainer(name: version.modelName)
    if let url = version.dbFileURL(directory, domainMask) {
      let store = NSPersistentStoreDescription(url: url)
      container.persistentStoreDescriptions = [store]
    }

    container.loadPersistentStores { (description, error) in
      if let error = error {
        fatalError("Core Data Store Failed \(error.localizedDescription)")
      } else {
        print("Core Data Store success")
      }
    }
  }
}

// MARK: - Versioning

extension CoreDataStack.Version {
  static var actual: UInt { 1 }
}

extension CoreDataStack {
  struct Version {
    private let number: UInt

    init(_ number: UInt) {
      self.number = number
    }

    var modelName: String {
      return "db_model"
    }

    func dbFileURL(
      _ directory: FileManager.SearchPathDirectory,
      _ domainMask: FileManager.SearchPathDomainMask
    ) -> URL? {
      return FileManager.default
        .urls(for: directory, in: domainMask).first?
        .appendingPathComponent(subpathToDB)
    }

    private var subpathToDB: String {
      return "db.sql"
    }
  }
}
