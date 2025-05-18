import XCTest
@testable import CodableAdvance

final class DecodableDictionaryTests: XCTestCase {
    
    // Test structures
    struct Person: Decodable, Equatable {
        let name: String
        let age: Int
        
        static func == (lhs: Person, rhs: Person) -> Bool {
            return lhs.name == rhs.name && lhs.age == rhs.age
        }
    }
    
    // Test dictionary
    let validDictionary: [AnyHashable: Any] = [
        "name": "John Doe",
        "age": 30
    ]
    
    let validStringDictionary: [String: Any] = [
        "name": "John Doe",
        "age": 30
    ]
    
    let invalidDictionary: [AnyHashable: Any] = [
        "name": "John Doe",
        "age": "thirty" // Should be an Int
    ]
    
    // MARK: - Tests for throwing initializer
    
    func testInitWithValidDictionary() throws {
        // Given a valid dictionary
        
        // When initializing with the throwing initializer
        let person = try Person(dictionary: validDictionary)
        
        // Then the object should be properly constructed
        XCTAssertEqual(person.name, "John Doe")
        XCTAssertEqual(person.age, 30)
    }
    
    func testInitWithInvalidDictionaryThrows() {
        // Given an invalid dictionary
        
        // When trying to initialize with the throwing initializer
        XCTAssertThrowsError(try Person(dictionary: invalidDictionary)) { error in
            // Then a decoding error should be thrown
            XCTAssertTrue(error is Swift.DecodingError)
        }
    }
    
    func testInitWithValidStringDictionary() throws {
        // Given a valid string dictionary
        
        // When initializing with the throwing initializer for string dictionaries
        let person = try Person(dictionary: validStringDictionary)
        
        // Then the object should be properly constructed
        XCTAssertEqual(person.name, "John Doe")
        XCTAssertEqual(person.age, 30)
    }
    
    // MARK: - Tests with custom options and decoder
    
    func testInitWithCustomOptions() throws {
        // Given a dictionary with special characters
        let specialDictionary: [AnyHashable: Any] = [
            "name": "John \"Quotes\" Doe",
            "age": 30
        ]
        
        // When initializing with custom JSON writing options
        let person = try Person(dictionary: specialDictionary, options: .fragmentsAllowed)
        
        // Then the object should be properly constructed
        XCTAssertEqual(person.name, "John \"Quotes\" Doe")
        XCTAssertEqual(person.age, 30)
    }
    
    func testInitWithCustomDecoder() throws {
        // Given a valid dictionary and a custom decoder
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        // When initializing with the custom decoder
        let person = try Person(dictionary: validDictionary, decoder: decoder)
        
        // Then the object should be properly constructed
        XCTAssertEqual(person.name, "John Doe")
        XCTAssertEqual(person.age, 30)
    }
    
    // MARK: - Tests for Dictionary.decode<T: Decodable>() method
    
    func testDictionaryDecodeWithValidData() throws {
        // Given a valid dictionary
        
        // When decoding the dictionary into a Person object
        let person: Person = try validStringDictionary.decode()
        
        // Then the object should be properly constructed
        XCTAssertEqual(person.name, "John Doe")
        XCTAssertEqual(person.age, 30)
    }
    
    func testDictionaryDecodeWithInvalidDataThrows() {
        // Given an invalid dictionary
        let invalidStringDict: [String: Any] = [
            "name": "John Doe",
            "age": "thirty" // Should be an Int
        ]
        
        // When trying to decode the dictionary
        XCTAssertThrowsError(try invalidStringDict.decode() as Person) { error in
            // Then a decoding error should be thrown
            XCTAssertTrue(error is Swift.DecodingError)
        }
    }
    
    func testDictionaryDecodeWithCustomOptions() throws {
        // Given a dictionary with special characters
        let specialStringDict: [String: Any] = [
            "name": "John \"Quotes\" Doe",
            "age": 30
        ]
        
        // When decoding with custom JSON writing options
        let person: Person = try specialStringDict.decode(options: .fragmentsAllowed)
        
        // Then the object should be properly constructed
        XCTAssertEqual(person.name, "John \"Quotes\" Doe")
        XCTAssertEqual(person.age, 30)
    }
    
    func testDictionaryDecodeWithCustomDecoder() throws {
        // Given a valid dictionary and a custom decoder
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        // Test with snake_case keys
        let snakeCaseDict: [String: Any] = [
            "name": "John Doe",
            "age": 30
        ]
        
        // When decoding with the custom decoder
        let person: Person = try snakeCaseDict.decode(decoder)
        
        // Then the object should be properly constructed
        XCTAssertEqual(person.name, "John Doe")
        XCTAssertEqual(person.age, 30)
    }
    
    func testDictionaryDecodeWithNestedStructures() throws {
        // Define a nested structure
        struct Company: Decodable, Equatable {
            let name: String
            let employees: [Person]
            
            static func == (lhs: Company, rhs: Company) -> Bool {
                return lhs.name == rhs.name && lhs.employees == rhs.employees
            }
        }
        
        // Given a dictionary with nested structures
        let nestedDict: [String: Any] = [
            "name": "ACME Corp",
            "employees": [
                ["name": "John Doe", "age": 30],
                ["name": "Jane Smith", "age": 25]
            ]
        ]
        
        // When decoding the nested dictionary
        let company: Company = try nestedDict.decode()
        
        // Then the object should be properly constructed with nested objects
        XCTAssertEqual(company.name, "ACME Corp")
        XCTAssertEqual(company.employees.count, 2)
        XCTAssertEqual(company.employees[0].name, "John Doe")
        XCTAssertEqual(company.employees[0].age, 30)
        XCTAssertEqual(company.employees[1].name, "Jane Smith")
        XCTAssertEqual(company.employees[1].age, 25)
    }
}
