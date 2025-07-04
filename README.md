# CodableAdvance

[![Swift Version](https://img.shields.io/badge/Swift-5.5+-orange.svg)](https://swift.org/)
[![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Swift Tests](https://github.com/inekipelov/swift-codable-advance/actions/workflows/swift.yml/badge.svg)](https://github.com/inekipelov/swift-codable-advance/actions/workflows/swift.yml)  
[![iOS](https://img.shields.io/badge/iOS-13.0+-blue.svg)](https://developer.apple.com/ios/)
[![macOS](https://img.shields.io/badge/macOS-10.15+-white.svg)](https://developer.apple.com/macos/)
[![tvOS](https://img.shields.io/badge/tvOS-13.0+-black.svg)](https://developer.apple.com/tvos/)
[![watchOS](https://img.shields.io/badge/watchOS-6.0+-orange.svg)](https://developer.apple.com/watchos/)

A library of extensions for Swift Codable protocols, simplifying the process of encoding and decoding objects.

## Features

- Easy conversion between `Data` and Codable objects
- Convenient conversion between dictionaries and Codable objects
- Filtering of invalid elements when decoding arrays (compactMap for decoding)
- Minimal configuration, easy-to-use API
- Fully compatible with existing Codable types

## Installation

### Swift Package Manager

Add the dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/inekipelov/swift-codable-advance.git", from: "0.1.0")
]
```

And specify "CodableAdvance" as a dependency for your target module:

```swift
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["CodableAdvance"]),
]
```

## Usage Examples

### Decoding from Data

```swift
import CodableAdvance

struct User: Codable {
    let id: Int
    let name: String
}

// Decoding from Data
let jsonData = """
{
    "id": 1,
    "name": "John"
}
""".data(using: .utf8)!

do {
    let user = try User(data: jsonData)
    print(user.name) // "John"
} catch {
    print("Decoding error: \(error)")
}
```

### Decoding from Dictionary

```swift
let dictionary: [String: Any] = ["id": 2, "name": "Mary"]

do {
    let user = try User(dictionary: dictionary)
    print(user.name) // "Mary"
} catch {
    print("Decoding error: \(error)")
}

// Or using the Dictionary extension
do {
    let user: User = try dictionary.decode()
    print(user.name) // "Mary"
} catch {
    print("Decoding error: \(error)")
}
```

### Encoding to Data

```swift
let user = User(id: 3, name: "Alex")

do {
    let data = try user.encodedData()
    // Use data for network transmission or storage
} catch {
    print("Encoding error: \(error)")
}
```

### Encoding to Dictionary

```swift
do {
    let dict = try user.encodedDictionary()
    print(dict["name"] as? String) // "Alex"
} catch {
    print("Encoding error: \(error)")
}
```

### Encoding Array to JSON String

```swift
let users = [
    User(id: 1, name: "John"),
    User(id: 2, name: "Mary"),
    User(id: 3, name: "Alex")
]

// Basic encoding to string
do {
    let jsonString = try users.encodedString()
    print(jsonString) // [{"id":1,"name":"John"},{"id":2,"name":"Mary"},{"id":3,"name":"Alex"}]
} catch {
    print("Encoding error: \(error)")
}

// Pretty-printing with custom encoder
do {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    let prettyJsonString = try users.encodedString(encoder: encoder)
    print(prettyJsonString)
    // Output:
    // [
    //   {
    //     "id": 1,
    //     "name": "John"
    //   },
    //   {
    //     "id": 2,
    //     "name": "Mary"
    //   },
    //   {
    //     "id": 3,
    //     "name": "Alex"
    //   }
    // ]
} catch {
    print("Encoding error: \(error)")
}

// Using custom string encoding
do {
    let asciiString = try users.encodedString(encoding: .ascii)
    // Use ASCII-encoded string
} catch {
    print("Encoding error: \(error)")
}
```

### Filtering Invalid Elements in Arrays

#### Using Container Extensions

```swift
struct Response: Decodable {
    let users: [User]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        users = try container.compactDecode(User.self, forKey: .users)
    }
    
    enum CodingKeys: String, CodingKey {
        case users
    }
}

// Some array elements are invalid
let jsonWithInvalidItems = """
{
    "users": [
        {"id": 1, "name": "John"},
        {"invalid": true},
        {"id": 2, "name": "Mary"}
    ]
}
""".data(using: .utf8)!

do {
    let response = try Response(data: jsonWithInvalidItems)
    print(response.users.count) // 2, invalid element is skipped
} catch {
    print("Decoding error: \(error)")
}
```

#### Direct Array Decoding with Skip Invalid Option

```swift
// Some array elements are invalid
let invalidArrayJson = """
[
    {"id": 1, "name": "John"},
    {"invalid": true},
    {"id": 2, "name": "Mary"}
]
""".data(using: .utf8)!

// Option 1: Standard decoding (will throw on invalid elements)
do {
    let users = try [User](data: invalidArrayJson)
    print(users.count)
} catch {
    print("Decoding failed due to invalid elements: \(error)")
}

// Option 2: Skip invalid elements
do {
    let users = try [User](data: invalidArrayJson, withCompactDecode: true)
    print(users.count) // 2, invalid element is skipped
    
    // Users array only contains valid elements
    users.forEach { user in
        print("User: \(user.name)")
    }
} catch {
    print("Decoding error: \(error)")
}
```

#### Direct Access to CompactDecodeArray

`CompactDecodeArray` struct allowing for more advanced use cases:

```swift
// Useful when you need direct access to the compact decoding mechanism
let decoder = JSONDecoder()
let compactArray = try decoder.decode(CompactDecodeArray<User>.self, from: jsonData)
let validUsers = compactArray.elements

// Or when you need to use it in your own container types
struct CustomContainer<T: Decodable>: Decodable {
    let items: [T]
    let metadata: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Use CompactDecodeArray directly to filter invalid items
        let itemsContainer = try container.decode(CompactDecodeArray<T>.self, forKey: .items)
        self.items = itemsContainer.elements
        self.metadata = try container.decode(String.self, forKey: .metadata)
    }
    
    enum CodingKeys: String, CodingKey {
        case items, metadata
    }
}
```

## License

CodableAdvance is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
