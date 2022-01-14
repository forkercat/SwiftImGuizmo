// swift-tools-version:5.3
import PackageDescription

var package = Package(
    name: "ImGuizmo",
    products: [
        .library(name: "ImGuizmo", targets: ["ImGuizmo"])
    ],
    dependencies: [
        .package(name: "ImGui", url: "https://github.com/forkercat/SwiftImGui.git", .branch("update-1.86-docking")),
    ],
    targets: [
        .target(name: "ImGuizmo", dependencies: [.byName(name: "CImGuizmo")]),
        .target(name: "CImGuizmo", dependencies: [.product(name: "ImGui", package: "ImGui")]),
        .target(name: "AutoWrapper"),
    ],
    cxxLanguageStandard: .cxx11
)
