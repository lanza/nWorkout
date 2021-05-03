import json
import datetime
from dataclasses import dataclass
from dataclasses_json import dataclass_json
from pprint import pprint
from typing import List


@dataclass_json
@dataclass
class Set:
    completedReps: int
    completedWeight: float
    reps: int
    weight: float
    note: str
    isWarmup: bool
    isWorkout: bool

    def __repr__(self) -> str:
        return f"{self.weight} x {self.reps} -> {self.completedWeight} x {self.completedReps}"


@dataclass_json
@dataclass
class Lift:
    name: str
    sets: List[Set]

    def __repr__(self) -> str:
        s = f"""
    Lift(name: {self.name},
      sets: [
"""
        for st in self.sets:
            s += "        " + repr(st) + ",\n"
        s += "])"
        s.lstrip()
        return s


@dataclass_json
@dataclass
class Workout:
    isComplete: bool
    finishDate: datetime.datetime
    isWorkout: bool
    lifts: List[Lift]
    name: str
    note: str
    startDate: datetime.datetime

    def __repr__(self):
        s = f"""
Workout(
  isComplete: {self.isComplete},
  startDate: {self.startDate},
  finishDate: {self.finishDate},
  lifts: [
          """
        for lift in self.lifts:
            s += "  " + repr(lift) + ",\n"
        s += "])"
        s.lstrip()
        return s


def map_to_workouts(data) -> List[Workout]:
    workouts: List[Workout] = []
    for workout in data:
        workouts.append(Workout.from_dict(workout))

    workouts.sort(key=lambda wo: wo.startDate)
    return workouts


coredata_start_date = datetime.datetime(2001, 1, 1, 0, 0, 0, 0, tzinfo=None)


def convert(i: float) -> datetime.datetime:
    return datetime.datetime.fromtimestamp(i + coredata_start_date.timestamp())


def get_data() -> List[Workout]:
    original_data = json.load(open("/Users/lanza/Downloads/data 5.json", "r"))
    originals = map_to_workouts(original_data)
    return originals


# regenerated_data = json.load(
#     open(
#         "/Users/lanza/Library/Developer/CoreSimulator/Devices/92921F5F-BDF7-45BD-A3C9-8B39ABBFA715/data/Containers/Shared/AppGroup/65403EFD-DD6D-4396-AAB1-13364F348F5A/File Provider Storage/data.json",
#         "r",
#     )
# )
# regenerated = map_to_workouts(regenerated_data)

originals = get_data()

pprint(originals)
print(len(originals))
# print(len(regenerated))

# print(originals == regenerated)
