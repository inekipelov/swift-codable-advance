//
// EncodableArray+Data.swift
// Utilities for encoding arrays of model objects into data
//

import Foundation

/// Extension providing functionality to encode arrays to data
public extension Array where Element: Encodable {
    /// Encodes this array into data using the given encoder.
    /// 
    /// This method provides a convenient way to encode an array of encodable elements.
    /// 
    /// ```swift
    /// // Encode array of users to JSON data
    /// let usersData = try users.encodedData()
    /// 
    /// // Encode with custom encoder
    /// let encoder = JSONEncoder()
    /// encoder.outputFormatting = .prettyPrinted
    /// let prettyData = try users.encodedData(encoder: encoder)
    /// ```
    ///
    /// - Parameter encoder: The encoder to use for encoding. Defaults to a new instance of `JSONEncoder`.
    /// - Returns: The encoded data.
    /// - Throws: An error if encoding fails.
    func encodedData(encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        return try encoder.encode(self)
    }
}
