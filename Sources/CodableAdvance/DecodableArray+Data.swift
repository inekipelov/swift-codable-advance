//
// DecodableArray+Data.swift
// Utilities for decoding arrays of model objects from data
//

import Foundation

public extension Array where Element: Decodable {
    /// Creates a new array by decoding from the given data.
    /// - Parameters:
    ///   - data: The data to decode from.
    ///   - decoder: The decoder to use for decoding. Defaults to a new instance of `JSONDecoder`.
    ///   - compact: A Boolean value indicating whether to use compact decoding. If `true`, invalid elements are skipped.
    /// - Throws: An error if decoding fails.
    init(data: Data, decoder: JSONDecoder = JSONDecoder(), skipInvalid: Bool = false) throws {
        if skipInvalid {
            self = try decoder.decode(CompactDecodeContainer<Element>.self, from: data).elements
        } else {
            self = try decoder.decode([Element].self, from: data)
        }
    }
}

/// A container used for decoding arrays with compactMap functionality
private struct CompactDecodeContainer<T: Decodable>: Decodable {
    let elements: [T]
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        elements = container.compactDecode(T.self)
    }
}
