import json
import datetime
from dataclasses import dataclass
from dataclasses_json import dataclass_json
from pprint import pprint
from typing import List

original_data = json.load(open("data.json", "r"))
regenerated_data = json.load(
    open(
        "/Users/lanza/Library/Developer/CoreSimulator/Devices/92921F5F-BDF7-45BD-A3C9-8B39ABBFA715/data/Containers/Shared/AppGroup/65403EFD-DD6D-4396-AAB1-13364F348F5A/File Provider Storage/data.json",
        "r",
    )
)

weight = []

coredata_start_date = datetime.datetime(2001, 1, 1, 0, 0, 0, 0, tzinfo=None)


def convert(i: float) -> datetime.datetime:
    return datetime.datetime.fromtimestamp(i + coredata_start_date.timestamp())


# for workout in data:
#     date = workout["startDate"]
#     date = convert(date)
#     for lift in workout["lifts"]:
#         if lift["name"] == "Squat":
#             for set in lift["sets"]:
#                 weight.append((set["completedWeight"], date))


# for i in weight:
#     print(i)

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

@dataclass_json
@dataclass
class Lift:
    name: str
    sets: List[Set]

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


def map_to_workouts(data) -> List[Workout]:
    workouts: List[Workout] = []
    for workout in data:
        workouts.append(Workout.from_dict(workout))

    workouts.sort(key=lambda wo: wo.startDate)
    return workouts

originals = map_to_workouts(original_data)
regenerated = map_to_workouts(regenerated_data)

print(len(originals))
print(len(regenerated))

print(originals == regenerated)
