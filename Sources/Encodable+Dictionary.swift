//
// Encodable+Dictionary.swift
// Utilities for encoding model objects into dictionaries
//

import Foundation

public extension Encodable {
    /// Encodes this value into a dictionary representation.
    /// - Parameters:
    ///   - encoder: The encoder to use for encoding. Defaults to a new instance of `JSONEncoder`.
    ///   - readingOptions: Options for reading the JSON data. Defaults to an empty set.
    /// - Returns: A dictionary representation of this value.
    /// - Throws: An error if encoding or converting to dictionary fails.
    func encodedDictionary(
        encoder: JSONEncoder = JSONEncoder(),
        readingOptions: JSONSerialization.ReadingOptions = []
    ) throws -> [String: Any] {
        let data = try encodedData(encoder: encoder)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: readingOptions) as? [String: Any] else {
            return [:]
        }
        return dictionary
    }
}
