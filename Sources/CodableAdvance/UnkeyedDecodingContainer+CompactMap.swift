//
//  UnkeyedDecodingContainer+CompactMap.swift
//  Utilities for handling array decoding with filtering invalid elements in unkeyed containers
//

import Foundation

public extension UnkeyedDecodingContainer {
    /// Decodes an array of elements, skipping invalid elements.
    /// - Parameter type: The type of elements to decode.
    /// - Returns: An array of successfully decoded elements.
    mutating func compactDecode<T: Decodable>(_ type: T.Type) -> [T] {
        var elements: [T] = []
        while !self.isAtEnd {
            if let element = try? self.decodeIfPresent(T.self) {
                elements.append(element)
            } else {
                // Skip invalid element
                _ = try? self.decode(AnyDecodable.self)
            }
        }
        
        return elements
    }
}

/// A placeholder type used to skip invalid elements during decoding.
private struct AnyDecodable: Decodable {}
