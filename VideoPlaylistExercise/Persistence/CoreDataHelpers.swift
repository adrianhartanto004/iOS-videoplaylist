import CoreData

protocol ManagedEntity: NSFetchRequestResult { }

extension ManagedEntity where Self: NSManagedObject {
  static func insertNew(in context: NSManagedObjectContext) -> Self? {
    return NSEntityDescription
      .insertNewObject(forEntityName: Constants.DBName.videoENT, into: context) as? Self
  }

  static func newFetchRequest() -> NSFetchRequest<Self> {
    return .init(entityName: Constants.DBName.videoENT)
  }
}

// MARK: - NSManagedObjectContext

extension NSManagedObjectContext {

  func configureAsReadOnlyContext() {
    automaticallyMergesChangesFromParent = true
    mergePolicy = NSRollbackMergePolicy
    undoManager = nil
    shouldDeleteInaccessibleFaults = true
  }

  func configureAsUpdateContext() {
    mergePolicy = NSOverwriteMergePolicy
    undoManager = nil
  }
}

// MARK: - Misc

extension NSSet {
  func toArray<T>(of type: T.Type) -> [T] {
    allObjects.compactMap { $0 as? T }
  }
}
