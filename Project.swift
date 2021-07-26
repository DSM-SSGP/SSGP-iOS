import ProjectDescription


// MARK: - Project

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project(
    name: "SSGP",
    organizationName: "com.ssgp",
    targets: [
        Target(
            name: "SSGP",
            platform: .iOS,
            product: .app,
            bundleId: "com.ssgp.SSGP",
            deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
            infoPlist: .file(path: Path("Supporting Files/Info.plist")),
            sources: ["Sources/**"],
            resources: ["Resources/**", "Supporting Files/**"],
            actions: [
                TargetAction.pre(
                    script: "${PODS_ROOT}/SwiftLint/swiftlint",
                    name: "SwiftLint"
                ),
                TargetAction.pre(
                    path: Path("Scripts/RSwiftRunScript.sh"),
                    arguments: [],
                    name: "R.Swift",
                    inputPaths: [Path.init("$TEMP_DIR/rswift-lastrun")],
                    inputFileListPaths: [],
                    outputPaths: [Path.init("$SRCROOT/Supporting Files/R.generated.swift")],
                    outputFileListPaths: []
                )
            ],
            dependencies: [
                .cocoapods(path: ".")
            ]
        )
    ],
    additionalFiles: [
        "Supporting Files/R.generated.swift",
        "Supporting Files/GoogleService-Info.plist"
    ]
)
