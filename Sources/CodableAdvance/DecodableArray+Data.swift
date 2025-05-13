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
    ///   - withCompactDecode: A Boolean value indicating whether to use compact decoding. If `true`, invalid elements are skipped.
    /// - Throws: An error if decoding fails.
    init(data: Data, decoder: JSONDecoder = JSONDecoder(), withCompactDecode: Bool = false) throws {
        if withCompactDecode {
            self = try decoder.decode(CompactDecodeArray<Element>.self, from: data).elements
        } else {
            self = try decoder.decode([Element].self, from: data)
        }
    }
}

/// A container used for decoding arrays with compactMap functionality.
/// This struct filters out elements that fail to decode properly, similar to `compactMap`.
/// You can use it directly when you need more control over the decoding process.
public struct CompactDecodeArray<T: Decodable>: Decodable {
    /// The array of successfully decoded elements
    public let elements: [T]
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        elements = container.compactDecode(T.self)
    }
}
