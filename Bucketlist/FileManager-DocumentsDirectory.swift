//
//  FileManager-DocumentsDirectory.swift
//  Bucketlist
//
//  Created by Mathieu Dubart on 24/09/2023.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
