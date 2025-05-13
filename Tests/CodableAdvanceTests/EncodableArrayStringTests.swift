import XCTest
@testable import CodableAdvance

final class EncodableArrayStringTests: XCTestCase {
    // Test model for use in tests
    private struct TestModel: Codable, Equatable {
        let id: Int
        let name: String
        
        static func == (lhs: TestModel, rhs: TestModel) -> Bool {
            return lhs.id == rhs.id && lhs.name == rhs.name
        }
    }
    
    // MARK: - Test Data
    
    private var testArray: [TestModel] {
        return [
            TestModel(id: 1, name: "Item 1"),
            TestModel(id: 2, name: "Item 2"),
            TestModel(id: 3, name: "Item 3")
        ]
    }
    
    // MARK: - Tests
    
    func testEncodedString() throws {
        // Setup
        let array = testArray
        
        // Action
        let jsonString = try array.encodedString()
        
        // Verification
        XCTAssertNotNil(jsonString)
        XCTAssertTrue(jsonString.contains("\"id\":1"))
        XCTAssertTrue(jsonString.contains("\"name\":\"Item 1\""))
        
        // Additional verification: convert back to data and decode
        guard let data = jsonString.data(using: .utf8) else {
            XCTFail("Failed to convert JSON string back to data")
            return
        }
        
        let decodedArray = try JSONDecoder().decode([TestModel].self, from: data)
        XCTAssertEqual(decodedArray, array)
    }
    
    func testEncodedStringWithCustomEncoding() throws {
        // Setup
        let array = testArray
        
        // Action
        let jsonString = try array.encodedString(encoding: .ascii)
        
        // Verification
        XCTAssertNotNil(jsonString)
        
        // Additional verification: convert back using ASCII encoding
        guard let data = jsonString.data(using: .ascii) else {
            XCTFail("Failed to convert JSON string back to data")
            return
        }
        
        let decodedArray = try JSONDecoder().decode([TestModel].self, from: data)
        XCTAssertEqual(decodedArray, array)
    }
    
    func testEncodedStringWithCustomEncoder() throws {
        // Setup
        let array = testArray
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        // Action
        let jsonString = try array.encodedString(encoder: encoder)
        
        // Verification
        XCTAssertNotNil(jsonString)
        XCTAssertTrue(jsonString.contains("\n"))
        
        // Make sure the pretty-printed JSON can be correctly decoded back
        guard let data = jsonString.data(using: .utf8) else {
            XCTFail("Failed to convert JSON string back to data")
            return
        }
        
        let decodedArray = try JSONDecoder().decode([TestModel].self, from: data)
        XCTAssertEqual(decodedArray, array)
    }
    
    func testEncodedStringWithEmptyArray() throws {
        // Setup
        let emptyArray: [TestModel] = []
        
        // Action
        let jsonString = try emptyArray.encodedString()
        
        // Verification
        XCTAssertEqual(jsonString, "[]")
        
        // Ensure it can be decoded back to an empty array
        guard let data = jsonString.data(using: .utf8) else {
            XCTFail("Failed to convert JSON string back to data")
            return
        }
        
        let decodedArray = try JSONDecoder().decode([TestModel].self, from: data)
        XCTAssertTrue(decodedArray.isEmpty)
    }
}
