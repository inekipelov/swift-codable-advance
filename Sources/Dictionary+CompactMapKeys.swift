//
//  Dictionary+CompactMapKeys.swift
//

internal extension Dictionary {
    func compactMapKeys<T>(_ transform: (Key) throws -> T?) rethrows -> [T : Value] {
        var result: [T: Value] = [:]
        for (key, value) in self {
            if let newKey = try transform(key) {
                result[newKey] = value
            }
        }
        return result
    }
}
