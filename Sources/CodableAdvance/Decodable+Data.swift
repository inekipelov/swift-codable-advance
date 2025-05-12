//
// Decodable+Data.swift
// Utilities for decoding data into model objects
//

import Foundation

public extension Decodable {
    /// Creates a new instance by decoding from the given data.
    /// - Parameters:
    ///   - data: The data to decode from.
    ///   - decoder: The decoder to use for decoding. Defaults to a new instance of `JSONDecoder`.
    /// - Throws: An error if decoding fails.
    init(data: Data, decoder: JSONDecoder = JSONDecoder()) throws {
        self = try decoder.decode(Self.self, from: data)
    }
}
