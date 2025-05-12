import XCTest
@testable import CodableAdvance

final class DecodableDataTests: XCTestCase {
    
    // Test structure
    struct Person: Decodable, Equatable {
        let name: String
        let age: Int
        
        static func == (lhs: Person, rhs: Person) -> Bool {
            return lhs.name == rhs.name && lhs.age == rhs.age
        }
    }
    
    // Test data
    let validJSON = """
    {
        "name": "John Doe",
        "age": 30
    }
    """.data(using: .utf8)!
    
    let invalidJSON = """
    {
        "name": "John Doe",
        "age": "thirty"
    }
    """.data(using: .utf8)!
    
    // MARK: - Tests for throwing initializer
    
    func testInitWithValidData() throws {
        // Given valid JSON data
        
        // When decoding into a Person type
        let person = try Person(data: validJSON)
        
        // Then the object should be decoded correctly
        XCTAssertEqual(person.name, "John Doe")
        XCTAssertEqual(person.age, 30)
    }
    
    func testInitWithInvalidDataThrows() {
        // Given invalid JSON data
        
        // When trying to decode into a Person type
        XCTAssertThrowsError(try Person(data: invalidJSON)) { error in
            // Then a decoding error should be thrown
            XCTAssertTrue(error is Swift.DecodingError)
        }
    }
    
    // MARK: - Tests for custom decoder
    
    func testWithCustomDecoder() throws {
        // Given valid JSON data and a custom decoder
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let snakeCaseJSON = """
        {
            "name": "Jane Smith",
            "age": 25
        }
        """.data(using: .utf8)!
        
        // When decoding with the custom decoder
        let person = try Person(data: snakeCaseJSON, decoder: decoder)
        
        // Then the object should be decoded correctly
        XCTAssertEqual(person.name, "Jane Smith")
        XCTAssertEqual(person.age, 25)
    }
}
