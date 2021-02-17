import json
import datetime

data = json.load(open("data.json", 'r'))

weight = []

coredata_start_date = datetime.datetime(2001, 1, 1, 0, 0, 0, 0, tzinfo=None)

def convert(i):
    return datetime.datetime.fromtimestamp(i + coredata_start_date.timestamp())


for workout in data:
    date = workout["startDate"]
    date = convert(date)
    for lift in workout["lifts"]:
        if lift["name"] == "Squat":
            for set in lift["sets"]:
                weight.append((set["completedWeight"], date))



for i in weight:
    print(i)
