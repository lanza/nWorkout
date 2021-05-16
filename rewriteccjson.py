import commentjson
from dataclasses import dataclass
from dataclasses_json import dataclass_json

from pprint import pprint
from typing import List, Dict, Union


@dataclass_json
@dataclass
class CompileCommand:
    file: str
    arguments: List[str]
    directory: str


js = commentjson.load(open("compile_commands.json", "r"))

ccs: List[CompileCommand] = []


for ele in js:
    ccs.append(CompileCommand.from_dict(ele))

final: List[CompileCommand] = []

for element in ccs:
    commands = element.arguments
    deletes = []
    for index, command in enumerate(commands):
        if (
            command == "-frontend"
            or command == "-enable-objc-interop"
            or command == "-serialize-debugging-options"
            or command == "-no-clang-module-breadcrumbs"
            or command == "-target-sdk-version"
        ):
            deletes.append(index)

        if command == "-target-sdk-version":
            deletes.append(index)
            deletes.append(index + 1)

    for i in reversed(deletes):
        del element.arguments[i]

    file = element.file
    if not "|" in file:
        final.append(element)
        continue

    files = file.split("|")

    for file in files:
        new = CompileCommand(file, element.arguments.copy(), element.directory)
        final.append(new)

jsout = list(map(lambda x: x.to_dict(), final))
jsonified = commentjson.dumps(jsout)
f = open("compile_command2s.json", "w")
f.write(jsonified)
f.close()
