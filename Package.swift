// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "Logistic",
    platforms: [
       .macOS(.v12),
    ],
    products: [
        .executable(name: "Run", targets: ["Run"]),
        .library(name: "App", targets: ["App"]),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", .branch("main")),
        .package(url: "https://github.com/vapor/fluent.git", .branch("main")),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", .branch("main")),
        .package(url: "https://github.com/vapor/jwt.git", .branch("main")),
        .package(url: "https://github.com/vapor/queues.git", .branch("main")),
        .package(url: "https://github.com/vapor/queues-redis-driver.git", .branch("main")),
        .package(url: "https://github.com/swift-server/async-http-client.git", .branch("main")),
        .package(url: "https://github.com/vapor-community/mailgun.git", from: "5.0.0")
    ],
    targets: [
        .target(name: "App", dependencies: [
            .product(name: "Fluent", package: "fluent"),
            .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
            .product(name: "Vapor", package: "vapor"),
            .product(name: "JWT", package: "jwt"),
            .product(name: "QueuesRedisDriver", package: "queues-redis-driver"),
            .product(name: "AsyncHTTPClient", package: "async-http-client"),
            .product(name: "Mailgun", package: "mailgun")
        ]),
        .target(name: "Run", dependencies: [
            .target(name: "App"),
        ]),
        .testTarget(name: "AppTests", dependencies: [
            .target(name: "App"),
            .product(name: "XCTVapor", package: "vapor"),
            .product(name: "XCTQueues", package: "queues")
        ])
    ]
)
