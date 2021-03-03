import CoreData
import Foundation

let coreDataStack = CoreDataStack(modelName: "Model")

class CoreDataStack {
  private let modelName: String

  init(modelName: String) {
    self.modelName = modelName

    self.context = NSManagedObjectContext(
      concurrencyType: .mainQueueConcurrencyType)
    context.persistentStoreCoordinator = persistentStoreCoordinator
  }
  let context: NSManagedObjectContext
  func getContext() -> NSManagedObjectContext {
    return context
  }

  private lazy var managedObjectModel: NSManagedObjectModel = {
    guard
      let modelURL = Bundle.main.url(
        forResource: modelName, withExtension: "momd")
    else {
      fatalError("Could not find model data")
    }
    guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
      fatalError("Unable t load data model")
    }
    return model
  }()

  private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
    let coordinator = NSPersistentStoreCoordinator(
      managedObjectModel: managedObjectModel)
    let fm = FileManager.default
    let storeName = "\(modelName).sqlite"
    let docDir = fm.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let url = docDir.appendingPathComponent(storeName)

    do {
      try coordinator.addPersistentStore(
        ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil
      )
    } catch {
      fatalError("Unable to load persistent store")
    }

    return coordinator
  }()
}
