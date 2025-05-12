# CodableAdvance

[![Swift Version](https://img.shields.io/badge/Swift-5.5+-orange.svg)](https://swift.org/)
[![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Swift Tests](https://github.com/inekipelov/swift-codable-advance/actions/workflows/swift.yml/badge.svg)](https://github.com/inekipelov/swift-codable-advance/actions/workflows/swift.yml)

A library of extensions for Swift Codable protocols, simplifying the process of encoding and decoding objects.

## Features

- Easy conversion between `Data` and Codable objects
- Convenient conversion between dictionaries and Codable objects
- Filtering of invalid elements when decoding arrays (compactMap for decoding)
- Minimal configuration, easy-to-use API
- Fully compatible with existing Codable types

## Requirements

- Swift 5.5+
- iOS 13.0+ / macOS 10.15+ / tvOS 13.0+ / watchOS 6.0+

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

### Filtering Invalid Elements in Arrays

```swift
struct Response: Decodable {
    let users: [User]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        users = container.decodeCompactMap(User.self, forKey: .users)
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

## License

CodableAdvance is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
