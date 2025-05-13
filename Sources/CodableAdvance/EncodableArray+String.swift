//
// EncodableArray+String.swift
// Utilities for encoding arrays of model objects into strings
//

import Foundation

public extension Array where Element: Encodable {
    /// Encodes this array into a JSON string using the given encoder.
    /// 
    /// This is a convenience method that encodes the array to data and then converts
    /// the data to a string using the specified encoding.
    ///
    /// ```swift
    /// // Encode array to JSON string
    /// let jsonString = try users.encodedString()
    /// 
    /// // Encode with pretty-printing
    /// let encoder = JSONEncoder()
    /// encoder.outputFormatting = .prettyPrinted
    /// let prettyJson = try users.encodedString(encoder: encoder)
    /// ```
    ///
    /// - Parameters:
    ///   - encoder: The encoder to use for encoding. Defaults to a new instance of `JSONEncoder`.
    ///   - encoding: The string encoding to use. Defaults to `.utf8`.
    /// - Returns: A JSON string representation of the array.
    /// - Throws: An error if encoding fails or if the data cannot be converted to a string.
    func encodedString(encoder: JSONEncoder = JSONEncoder(), encoding: String.Encoding = .utf8) throws -> String {
        let data = try self.encodedData(encoder: encoder)
        guard let string = String(data: data, encoding: encoding) else {
            throw EncodingError.invalidValue(self, EncodingError.Context(
                codingPath: [],
                debugDescription: "Failed to convert encoded data to string using \(encoding) encoding"
            ))
        }
        return string
    }
}
