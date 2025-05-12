//
// Decodable+Dictionary.swift
// Utilities for decoding dictionaries into model objects
//

import Foundation

public extension Decodable {
    /// Creates a new instance by decoding from the given dictionary.
    /// - Parameters:
    ///   - dictionary: The dictionary to decode from.
    ///   - decoder: The decoder to use for decoding. Defaults to a new instance of `JSONDecoder`.
    ///   - options: Options for creating the JSON data from the dictionary.
    /// - Throws: An error if conversion to JSON data or decoding fails.
    init(
        dictionary: [AnyHashable: Any],
        decoder: JSONDecoder = JSONDecoder(),
        options: JSONSerialization.WritingOptions = []
    ) throws {
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: options)
        try self.init(data: data, decoder: decoder)
    }
}

extension Dictionary where Key: Hashable, Value: Any {
    /// Converts the [AnyHashable: Any] dictionary into a strictly typed object of type T that conforms to the Decodable protocol.
    /// - Throws: Error on failed decoding attempt or data type mismatch.
    /// - Returns: An object of type T decoded from the dictionary.
    func decode<T: Decodable>(
        _ decoder: JSONDecoder = JSONDecoder(),
        options: JSONSerialization.WritingOptions = []
    ) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: self, options: options)
        return try decoder.decode(T.self, from: data)
    }
}
