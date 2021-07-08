//
//  main.swift
//
//
//  Created by Christian Treffs on 24.10.19.
//

import struct Foundation.URL
import struct Foundation.Data

public struct ConversionError: Swift.Error {
    public let localizedDescription: String
}

public func getDirectory(ofFile filePath: String = #file) -> String {
    guard let lastSlashIdx = filePath.lastIndex(of: "/") else {
        return filePath
    }
    var dirPath = filePath
    dirPath.removeSubrange(lastSlashIdx..<filePath.endIndex)
    return dirPath
}

// Input: <SRC_ROOT>/3rdparty/cimgui/generator/output/definitions.json
public let kInputFiles: [String]
// Output <SRC_ROOT>/Sources/ImGui/ImGui+Definitions.swift
public let kOutputFiles: [String]

if CommandLine.arguments.count == 3 {
    kInputFiles = [CommandLine.arguments[1]]
    kOutputFiles = [CommandLine.arguments[2]]
} else {
    let src = getDirectory() + "/../../3rdparty/cimgui/generator/output/"
    let dest = getDirectory() + "/../ImGui/"
    kInputFiles = ["definitions.json"].map { "\(src)\($0)" }
    kOutputFiles = ["ImGui+Definitions.swift"].map { "\(dest)\($0)" }
}

public let kHeader = """
// -- THIS FILE IS AUTOGENERATED - DO NOT EDIT!!! ---

import ImGui
import CImGuizmo

// swiftlint:disable identifier_name
"""

public let kFooter = """
"""

for (inputFile, outputFile) in zip(kInputFiles, kOutputFiles) {
    try convert(filePath: inputFile, validOnly: true) { body in
        let out: String = [kHeader, body, kFooter].joined(separator: "\n\n")

        guard let data: Data = out.data(using: .utf8) else {
            throw ConversionError(localizedDescription: "Could not generate data from output string \(out)")
        }

        let outURL = URL(fileURLWithPath: outputFile)

        try data.write(to: outURL)
    }
}
