import CoreData
import Foundation

let coreDataStack = CoreDataStack(modelName: "Model")

class CoreDataStack {
  private let modelName: String

  let inMemory = false

  init(modelName: String) {
    self.modelName = modelName
    self.container = NSPersistentCloudKitContainer(name: "Model")

    #if inMemory
      container.persistentStoreDescriptions.first!.url = URL(
        fileURLWithPath: "/dev/null")
    #else
      let fm = FileManager.default
      let storeName = "\(modelName).sqlite"
      let docDir = fm.urls(for: .documentDirectory, in: .userDomainMask)[0]
      let url = docDir.appendingPathComponent(storeName)
      container.persistentStoreDescriptions.first!.url = url
    #endif

    container.loadPersistentStores(completionHandler: {
      (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })

    // no idea what this does...
    getContext().automaticallyMergesChangesFromParent = true
    do {
      try container.viewContext.setQueryGenerationFrom(.current)
    } catch {
      fatalError(
        "###\(#function): Failed to pin viewContext to the current generation:\(error)"
      )
    }
  }

  func getContext() -> NSManagedObjectContext {
    return container.viewContext
  }

  func saveContext() throws {
    let c = getContext()
    c.mergePolicy = NSMergePolicy(merge: .overwriteMergePolicyType)
    try c.save()
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
