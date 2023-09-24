//
//  Result.swift
//  Bucketlist
//
//  Created by Mathieu Dubart on 24/09/2023.
//

import Foundation

struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int: Page]
}

struct Page: Codable {
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
}
