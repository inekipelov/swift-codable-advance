//
// Encodable+Data.swift
// Utilities for encoding model objects into data
//

import Foundation

public extension Encodable {
    /// Encodes this value using the given encoder.
    /// - Parameter encoder: The encoder to use for encoding. Defaults to a new instance of `JSONEncoder`.
    /// - Returns: The encoded data.
    /// - Throws: An error if encoding fails.
    func encodedData(encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        return try encoder.encode(self)
    }
}