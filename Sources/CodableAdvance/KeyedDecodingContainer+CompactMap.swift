//
//  KeyedDecodingContainer+CompactMap.swift
//  Utilities for handling array decoding with filtering invalid elements
//

import Foundation

public extension KeyedDecodingContainer {
    /// Decodes an array of elements for the given key, skipping invalid elements.
    /// - Parameters:
    ///   - type: The type of elements to decode.
    ///   - key: The key for the nested container.
    /// - Returns: An array of successfully decoded elements.
    func decodeCompactMap<T: Decodable>(_ type: T.Type, forKey key: KeyedDecodingContainer.Key) throws -> [T] {
        var container = try nestedUnkeyedContainer(forKey: key)
        return container.decodeCompactMap(type)
    }
}
