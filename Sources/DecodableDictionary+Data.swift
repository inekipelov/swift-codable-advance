import Foundation

public extension Dictionary where Key: Hashable & Decodable & RawRepresentable, Key.RawValue: Hashable & Decodable, Value: Decodable {

    /// Initializes a dictionary from `Data` using a `JSONDecoder`.
    ///
    /// - Parameters:
    ///   - data: The data to decode, typically in JSON format.
    ///   - decoder: The `JSONDecoder` to use for decoding. Defaults to a new `JSONDecoder` instance.
    ///
    /// - Throws: An error if the data is not valid for the expected dictionary format or decoding fails.
    init(data: Data, decoder: JSONDecoder = JSONDecoder(), compactDecode: Bool = false) throws {
        if compactDecode {
            self = try decoder.decode(CompactDecodableDictionary<Key,Value>.self, from: data).keyedValues
        } else {
            self = try decoder.decode(DecodableDictionary<Key,Value>.self, from: data).keyedValues
        }
    }
}

/// A wrapper to allow decoding dictionaries with `RawRepresentable` keys from JSON.
///
/// Use when you want to decode a dictionary from JSON whose keys conform to `RawRepresentable`.
///
/// - Note: In Swift, decoding a `Dictionary` where `Key` is not `String` or `Int` fails, as the
/// decoder expects an `Array<Any>`. This structure resolves that limitation, enabling
/// safe decoding of JSON objects into dictionaries with custom string-based keys (e.g., enums).
///
/// **Swift Forum about problems around decoding custom Keys**
/// - [First Link](https://forums.swift.org/t/json-encoding-decoding-weird-encoding-of-dictionary-with-enum-values/12995])
/// - [Second Link](https://forums.swift.org/t/decoding-a-dictionary-with-a-custom-type-not-string-as-key/35290)
///
@dynamicMemberLookup
public struct DecodableDictionary<Key, Value>: Decodable where Key: Hashable & RawRepresentable, Key.RawValue: Hashable & Decodable, Value: Decodable {
    /// The dictionary of successfully decoded elements
    public let keyedValues: [Key: Value]

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let keyValuePair = try container.decode(
            [Key.RawValue: Value].self
        )
        self.keyedValues = keyValuePair.compactMapKeys {
            Key(rawValue: $0)
        }
    }
    
    public subscript<T>(dynamicMember keyPath: KeyPath<[Key: Value], T>) -> T {
        return keyedValues[keyPath: keyPath]
    }
    public subscript(key: Key) -> Value? {
        return keyedValues[key]
    }
}

///
/// A wrapper to enable decoding dictionaries from JSON where keys conform to `RawRepresentable`,
/// and values may fail to decode individually without causing the entire dictionary decoding to fail.
///
/// This structure attempts to decode each value using a failable decode mechanism, allowing
/// partial dictionary decoding when some values are invalid or corrupt.
///
/// - Parameters:
///   - Key: The dictionary key type, which must conform to `Hashable` and `RawRepresentable`.
///          The raw value type of the key must conform to `Hashable` and `Decodable`.
///   - Value: The value type of the dictionary, which must conform to `Decodable`.
///
/// - Usage:
/// ```swift
/// struct MyKey: RawRepresentable, Hashable, Decodable {
///     let rawValue: String
///     init?(rawValue: String) { self.rawValue = rawValue }
/// }
///
/// let jsonData = """
/// {
///     "validKey": { "someProperty": "value" },
///     "validKey": "butCorruptedData",
///     123: "andCorruptedData"
/// }
/// """.data(using: .utf8)!
///
/// let decoded = try JSONDecoder().decode(CompactDecodableDictionary<MyKey, MyValueType>.self, from: jsonData)
/// let dictionary = decoded.keyedValues
/// ```
///
@dynamicMemberLookup
public struct CompactDecodableDictionary<Key, Value>: Decodable where Key: Hashable & RawRepresentable, Key.RawValue: Hashable & Decodable, Value: Decodable {
    /// The dictionary of successfully decoded elements.
    ///
    /// Contains only the key-value pairs whose values were successfully decoded.
    public let keyedValues: [Key: Value]

    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer attempts to decode a dictionary whose values
    /// are wrapped in `FailableDecodable<Value>`, allowing individual
    /// values to fail decoding without failing the entire dictionary.
    ///
    /// - Parameter decoder: The decoder to read data from.
    /// - Throws: An error if the container cannot be decoded or keys cannot be mapped.
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let keyValuePair = try container.decode(
            [Key.RawValue: FailableDecodable<Value>].self
        )
        self.keyedValues = keyValuePair.compactMapKeys {
            Key(rawValue: $0)
        }.compactMapValues {
            $0.value
        }
    }

    /// Provides dynamic member lookup into the underlying dictionary.
    ///
    /// - Parameter keyPath: A key path to a property of the dictionary.
    /// - Returns: The value at the given key path.
    public subscript<T>(dynamicMember keyPath: KeyPath<[Key: Value], T>) -> T {
        return keyedValues[keyPath: keyPath]
    }

    /// Accesses the value associated with the given key.
    ///
    /// - Parameter key: A key of the dictionary type.
    /// - Returns: The value associated with `key` if it exists, otherwise `nil`.
    public subscript(key: Key) -> Value? {
        return keyedValues[key]
    }
}
