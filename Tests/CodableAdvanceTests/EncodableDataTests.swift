import XCTest
@testable import CodableAdvance

final class EncodableDataTests: XCTestCase {
    
    // Test structure
    struct Person: Encodable {
        let name: String
        let age: Int
    }
    
    // MARK: - Tests for encodedData method
    
    func testEncodedData() throws {
        // Given a Person object
        let person = Person(name: "John Doe", age: 30)
        
        // When encoding to data
        let data = try person.encodedData()
        
        // Then the data should be properly encoded
        let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        XCTAssertNotNil(dictionary)
        XCTAssertEqual(dictionary?["name"] as? String, "John Doe")
        XCTAssertEqual(dictionary?["age"] as? Int, 30)
    }
    
    func testEncodedDataWithCustomEncoder() throws {
        // Given a Person object and a custom encoder
        let person = Person(name: "Jane Smith", age: 25)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        // When encoding with the custom encoder
        let data = try person.encodedData(encoder: encoder)
        
        // Then the data should be properly encoded with the custom format
        let jsonString = String(data: data, encoding: .utf8)
        XCTAssertNotNil(jsonString)
        XCTAssertTrue(jsonString!.contains("\n")) // Pretty printed JSON has newlines
        
        // And should contain the correct values
        let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        XCTAssertNotNil(dictionary)
        XCTAssertEqual(dictionary?["name"] as? String, "Jane Smith")
        XCTAssertEqual(dictionary?["age"] as? Int, 25)
    }
    
    // MARK: - Tests for error handling
    
    func testEncodingError() {
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
        
        // When encoding with potential error
        XCTAssertThrowsError(try badPerson.encodedData()) { error in
            // Then an error should be thrown
            XCTAssertEqual((error as NSError).domain, "TestError")
            XCTAssertEqual((error as NSError).code, 123)
        }
    }
}
