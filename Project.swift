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
            resources: ["Resources/**"],
            actions: [
                
            ],
            dependencies: [
                .cocoapods(path: ".")
            ]
        )
    ],
    additionalFiles: [
        
    ]
)
