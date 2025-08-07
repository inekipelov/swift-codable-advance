//
//  FailableDecodable.swift
//

import Foundation

/// A wrapper that attempts to decode a value and returns nil if decoding fails.
public struct FailableDecodable<T: Decodable>: Decodable {
    public let value: T?

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            value = try container.decode(T.self)
        } catch {
            // Silently fail and assign nil
            value = nil
        }
    }
}
