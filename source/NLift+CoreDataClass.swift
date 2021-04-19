import CoreData
import Foundation

@objc(NLift)
public class NLift: NSManagedObject, DataProvider {

  func getOrderedSets() -> [NSet] {
    guard let sets = sets else { return [] }
    return sets.sorted(by: { (left, right) -> Bool in
      guard let l = left as? NSet, let r = right as? NSet else {
        fatalError("What?")
      }
      return l.index < r.index
    }) as! [NSet]
  }

  @nonobjc public class func getFetchRequest() -> NSFetchRequest<NLift> {
    return fetchRequest()
  }

  func getName() -> String {
    return type?.name ?? "Pending"
  }
  func setName(_ name: String) {
    type!.name = name
  }

  func fixupPreviousOccurrence() {
    // TODO: Clean up this garbage usage
    let elements = type!.getInstancesSorted()
    guard let thisIndex = elements.firstIndex(of: self), thisIndex > 0 else {
      return
    }

    previous = elements[thisIndex - 1]
  }

  static func new(name: String, workout: NWorkout) -> NLift {
    let lift = NLift(context: coreDataStack.getContext())
    lift.workout = workout

    // TODO: Clean up this garbage usage
    let types = try! coreDataStack.getContext().fetch(
      LiftType.getFetchRequest())

    lift.type =
      types.first(where: { $0.name == name }) ?? LiftType.new(name: name)
    lift.fixupPreviousOccurrence()

    lift.setName(name)

    return lift
  }

  func makeWorkoutLift(workout: NWorkout) -> NLift {
    let lift = NLift.new(name: getName(), workout: workout)

    for s in sets! {
      let set = s as! NSet
      let new = set.makeWorkoutSet(lift: self)
      lift.addToSets(new)
    }

    return lift
  }

  func append(_ object: NSet) {
    addToSets(object)
  }

  func numberOfItems() -> Int {
    return sets!.count
  }

  func getSetsSorted() -> [NSet] {
    return (sets!.map { $0 } as! [NSet]).sorted(by: { $0.index < $1.index })
  }

  func updateIndices(for sets: [NSet]) {
    for (index, set) in sets.enumerated() {
      set.index = Int64(index)
    }
  }

  func object(at index: Int) -> NSet {
    return getSetsSorted()[index]
  }

  func index(of object: NSet) -> Int? {
    return getSetsSorted().firstIndex(of: object)
  }

  func insert(_ object: NSet, at index: Int) {
    var elements = getSetsSorted()
    elements.insert(object, at: index)
    updateIndices(for: elements)
    addToSets(object)
  }

  func remove(at index: Int) {
    var elements = getSetsSorted()
    let ele = elements.remove(at: index)
    updateIndices(for: elements)
    removeFromSets(ele)
  }

  func move(from sourceIndex: Int, to destinationIndex: Int) {
    var elements = getSetsSorted()
    let removed = elements.remove(at: sourceIndex)
    elements.insert(removed, at: destinationIndex)
    updateIndices(for: elements)
  }

  static func makeDummy(name: String = "Riley Feeding") -> NLift {
    let l = NLift()
    let lt = LiftType()
    lt.name = name
    l.type = lt
    l.note = ""
    return l
  }

  static func createFromJLift(
    _ jlift: JLift, in nworkout: NWorkout, at index: Int
  ) -> NLift {
    let nl = NLift.new(name: jlift.name, workout: nworkout)
    nl.note = jlift.note
    nl.index = Int64(index)
    for (index, jset) in jlift.sets.enumerated() {
      nl.addToSets(NSet.createFromJSet(jset, in: nl, at: index))
    }
    return nl
  }

  func convertToJLift(in jworkout: JWorkout) -> JLift {
    let jlift = JLift.new(isWorkout: true, name: getName(), workout: jworkout)
    jlift.note = note ?? ""

    for set in getSetsSorted() {
      jlift.append(set.convertToJSet(in: jlift))
    }

    return jlift
  }
}
