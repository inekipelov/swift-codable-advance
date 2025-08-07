//
//  JSONDecoder+Modifier.swift
//

import Foundation

public extension JSONDecoder {
    func dateDecodingStrategy(_ strategy: DateDecodingStrategy) -> Self {
        self.dateDecodingStrategy = strategy
        return self
    }

    func dataDecodingStrategy(_ strategy: DataDecodingStrategy) -> Self {
        self.dataDecodingStrategy = strategy
        return self
    }

    func nonConformingFloatDecodingStrategy(_ strategy: NonConformingFloatDecodingStrategy) -> Self {
        self.nonConformingFloatDecodingStrategy = strategy
        return self
    }

    func keyDecodingStrategy(_ strategy: KeyDecodingStrategy) -> Self {
        self.keyDecodingStrategy = strategy
        return self
    }

    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func allowsJSON5(_ allowsJSON5: Bool) -> Self {
        self.allowsJSON5 = allowsJSON5
        return self
    }

    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func assumesTopLevelDictionary(_ assumesTopLevelDictionary: Bool) -> Self {
        self.assumesTopLevelDictionary = assumesTopLevelDictionary
        return self
    }
}
