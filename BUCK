
apple_resource(
    name = 'nWorkoutResources',
    files = glob(['*.png']),
    dirs = [],
)


apple_bundle(
    name = 'nWorkoutApp',
    binary = ':nWorkoutBinary',
    extension = 'app',
    info_plist = 'resources/info.plist',
)

apple_binary(
    name = 'nWorkoutBinary',
    deps = [':nWorkoutResources', '//source:work'],
)
