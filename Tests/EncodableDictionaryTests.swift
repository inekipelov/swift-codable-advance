import XCTest
@testable import CodableAdvance

final class EncodableDictionaryTests: XCTestCase {
    
    // Test structure
    struct Person: Encodable {
        let name: String
        let age: Int
    }
    
    // MARK: - Tests for encodedDictionary method
    
    func testEncodedDictionary() throws {
        // Given a Person object
        let person = Person(name: "John Doe", age: 30)
        
        // When encoding to dictionary
        let dictionary = try person.encodedDictionary()
        
        // Then the dictionary should contain the correct values
        XCTAssertEqual(dictionary["name"] as? String, "John Doe")
        XCTAssertEqual(dictionary["age"] as? Int, 30)
    }
    
    func testEncodedDictionaryWithReadingOptions() throws {
        // Given a Person object
        let person = Person(name: "John Doe", age: 30)
        
        // When encoding with specific reading options
        let dictionary = try person.encodedDictionary(readingOptions: .allowFragments)
        
        // Then the dictionary should contain the correct values
        XCTAssertEqual(dictionary["name"] as? String, "John Doe")
        XCTAssertEqual(dictionary["age"] as? Int, 30)
    }
    
    // MARK: - Tests for error handling
    
    func testEncodedDictionaryWithError() throws {
        // Create a struct that will fail encoding
        struct BadPerson: Encodable {
            let name: String
            let age: Int
            
            func encode(to encoder: Encoder) throws {
                // Simulate an encoding error
                throw NSError(domain: "TestError", code: 123, userInfo: [NSLocalizedDescriptionKey: "Test encoding error"])
            }
        }
        
        // Given a problematic object
        let badPerson = BadPerson(name: "Error Person", age: 0)
        
        // When encoding, it should throw an error
        XCTAssertThrowsError(try badPerson.encodedDictionary()) { error in
            XCTAssertEqual((error as NSError).domain, "TestError")
        }
    }
        
    // MARK: - Tests for additional dictionary features
    
    func testEncodedDictionaryWithNonStandardValues() throws {
        // Given a Person object with special characters
        let person = Person(name: "John \"Quotes\" Doe", age: 30)
        
        // When encoding to dictionary
        let dictionary = try person.encodedDictionary()
        
        // Then the dictionary should handle special characters correctly
        XCTAssertEqual(dictionary["name"] as? String, "John \"Quotes\" Doe")
    }
    
    // MARK: - Error handling tests
    
    func testEncodedDictionaryFailure() {
        // Create a problematic dictionary structure
        struct ComplexStruct: Encodable {
            let person: Person
            let nonJsonCompatible: (() -> Void)
            
            func encode(to encoder: Encoder) throws {
                // This will attempt to encode nonJsonCompatible which will fail
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(person, forKey: .person)
                // The following line would cause an encoding error
                // but we can't actually test it this way as Swift won't allow it
                // try container.encode(nonJsonCompatible, forKey: .nonJsonCompatible)
                
                // Instead, simulate an encoding error
                throw NSError(domain: "TestError", code: 0, userInfo: nil)
            }
            
            enum CodingKeys: String, CodingKey {
                case person, nonJsonCompatible
            }
        }
        
        let complex = ComplexStruct(
            person: Person(name: "John", age: 30),
            nonJsonCompatible: { print("This can't be encoded to JSON") }
        )
        
        // When trying to encode a struct with a closure (which can't be encoded to JSON)
        XCTAssertThrowsError(try complex.encodedDictionary()) { error in
            // Then an error should be thrown
            // We expect a specific TestError domain since we're throwing a custom NSError in the encode method
            let nsError = error as NSError
            XCTAssertEqual(nsError.domain, "TestError")
            XCTAssertEqual(nsError.code, 0)
        }
    }
}
