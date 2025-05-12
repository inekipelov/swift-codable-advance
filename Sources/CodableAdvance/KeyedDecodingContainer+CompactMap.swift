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
    func decodeCompactMap<T: Decodable>(_ type: T.Type, forKey key: KeyedDecodingContainer.Key) -> [T] {
        var elements: [T] = []

        if var container = try? nestedUnkeyedContainer(forKey: key) {
            while !container.isAtEnd {
                if let element = try? container.decodeIfPresent(T.self) {
                    elements.append(element)
                } else {
                    _ = try? container.decode(AnyDecodable.self)
                }
            }
        }

        return elements
    }
    
    /// A placeholder type used to skip invalid elements during decoding.
    private struct AnyDecodable: Decodable {}
}