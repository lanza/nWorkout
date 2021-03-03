import CoreData
import Foundation

let coreDataStack = CoreDataStack(modelName: "Model")

class CoreDataStack {
  private let modelName: String

  init(modelName: String) {
    self.modelName = modelName
    self.container = NSPersistentCloudKitContainer(name: "Model")

    // this would be used for testing and previews in SwiftUI
    let inMemory = false
    if inMemory {
      container.persistentStoreDescriptions.first!.url = URL(
        fileURLWithPath: "/dev/null")
    } else {
      let fm = FileManager.default
      let storeName = "\(modelName).sqlite"
      let docDir = fm.urls(for: .documentDirectory, in: .userDomainMask)[0]
      let url = docDir.appendingPathComponent(storeName)
      container.persistentStoreDescriptions.first!.url = url
    }

    container.loadPersistentStores(completionHandler: {
      (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })

    // self.context = NSManagedObjectContext(
    //   concurrencyType: .mainQueueConcurrencyType)
    // context.persistentStoreCoordinator = persistentStoreCoordinator
    // context.automaticallyMergesChangesFromParent = true
  }

  func getContext() -> NSManagedObjectContext {
    return container.viewContext
  }

  // let context: NSManagedObjectContext
  // func getContext() -> NSManagedObjectContext {
  //   return context
  // }

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

  let container: NSPersistentCloudKitContainer

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
