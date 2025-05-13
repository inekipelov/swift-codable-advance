import XCTest
@testable import CodableAdvance

final class DecodableArrayDataTests: XCTestCase {
    // Test model for use in tests
    private struct TestModel: Codable, Equatable {
        let id: Int
        let name: String
        
        static func == (lhs: TestModel, rhs: TestModel) -> Bool {
            return lhs.id == rhs.id && lhs.name == rhs.name
        }
    }
    
    // MARK: - Standard Decoding Tests
    
    func testStandardDecodingWithValidData() throws {
        let jsonString = """
        [
            {"id": 1, "name": "Item 1"},
            {"id": 2, "name": "Item 2"},
            {"id": 3, "name": "Item 3"}
        ]
        """
        let jsonData = jsonString.data(using: .utf8)!
        
        let decodedArray = try [TestModel](data: jsonData)
        
        XCTAssertEqual(decodedArray.count, 3)
        XCTAssertEqual(decodedArray[0].id, 1)
        XCTAssertEqual(decodedArray[0].name, "Item 1")
        XCTAssertEqual(decodedArray[1].id, 2)
        XCTAssertEqual(decodedArray[1].name, "Item 2")
        XCTAssertEqual(decodedArray[2].id, 3)
        XCTAssertEqual(decodedArray[2].name, "Item 3")
    }
    
    func testStandardDecodingWithInvalidData() {
        // Setup
        let jsonString = """
        [
            {"id": 1, "name": "Item 1"},
            {"invalid": "data"},
            {"id": 3, "name": "Item 3"}
        ]
        """
        let jsonData = jsonString.data(using: .utf8)!
        
        // Action and verification
        XCTAssertThrowsError(try [TestModel](data: jsonData)) { error in
            // Verify that the error occurred specifically due to decoding failure
            XCTAssertTrue(error is DecodingError)
        }
    }
    
    func testStandardDecodingWithEmptyArray() throws {
        // Setup
        let jsonString = "[]"
        let jsonData = jsonString.data(using: .utf8)!
        
        // Action
        let decodedArray = try [TestModel](data: jsonData)
        
        // Verification
        XCTAssertTrue(decodedArray.isEmpty)
    }
    
    func testStandardDecodingWithCustomDecoder() throws {
        // Setup
        let jsonString = """
        [
            {"id": 1, "name": "Item 1"},
            {"id": 2, "name": "Item 2"}
        ]
        """
        let jsonData = jsonString.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        // Action
        let decodedArray = try [TestModel](data: jsonData, decoder: decoder)
        
        // Verification
        XCTAssertEqual(decodedArray.count, 2)
    }
    
    // MARK: - Skip Invalid Tests
    
    func testSkipInvalidDecoding() throws {
        // Setup
        let jsonString = """
        [
            {"id": 1, "name": "Item 1"},
            {"invalid": "data"},
            {"id": 3, "name": "Item 3"}
        ]
        """
        let jsonData = jsonString.data(using: .utf8)!
        
        // Action
        let decodedArray = try [TestModel](data: jsonData, skipInvalid: true)
        
        // Verification
        XCTAssertEqual(decodedArray.count, 2)
        XCTAssertEqual(decodedArray[0].id, 1)
        XCTAssertEqual(decodedArray[0].name, "Item 1")
        XCTAssertEqual(decodedArray[1].id, 3)
        XCTAssertEqual(decodedArray[1].name, "Item 3")
    }
    
    func testSkipInvalidDecodingWithAllInvalidData() throws {
        // Setup
        let jsonString = """
        [
            {"invalid": "data1"},
            {"invalid": "data2"},
            {"invalid": "data3"}
        ]
        """
        let jsonData = jsonString.data(using: .utf8)!
        
        // Action
        let decodedArray = try [TestModel](data: jsonData, skipInvalid: true)
        
        // Verification
        XCTAssertTrue(decodedArray.isEmpty)
    }
    
    func testSkipInvalidDecodingWithMalformedJSON() {
        // Setup - malformed JSON
        let malformedJSON = "{ this is not valid JSON }".data(using: .utf8)!
        
        // Action and verification
        XCTAssertThrowsError(try [TestModel](data: malformedJSON, skipInvalid: true)) { error in
            // Even with skipInvalid=true, malformed JSON should still cause an error
            XCTAssertTrue(error is DecodingError)
        }
    }
    
    func testSkipInvalidDecodingWithMixedDataTypes() throws {
        // Setup - test data contains a mix of valid objects and incompatible types
        let jsonString = """
        [
            {"id": 1, "name": "Item 1"},
            42,
            {"id": 3, "name": "Item 3"}
        ]
        """
        let jsonData = jsonString.data(using: .utf8)!
        
        // Action
        let decodedArray = try [TestModel](data: jsonData, skipInvalid: true)
        
        // Verification - we expect invalid elements (number 42) to be skipped
        XCTAssertEqual(decodedArray.count, 2, "Only 2 valid elements should be decoded")
        
        // Check for the presence of expected elements
        let ids = decodedArray.map { $0.id }.sorted()
        XCTAssertEqual(ids, [1, 3], "Elements with IDs 1 and 3 should be present")
        
        // Verify specific elements by ID and name
        XCTAssertTrue(decodedArray.contains { $0.id == 1 && $0.name == "Item 1" })
        XCTAssertTrue(decodedArray.contains { $0.id == 3 && $0.name == "Item 3" })
    }
    
    // MARK: - Edge Cases
    
    func testNullData() {
        // Setup
        let jsonString = "null"
        let jsonData = jsonString.data(using: .utf8)!
        
        // Action and verification
        XCTAssertThrowsError(try [TestModel](data: jsonData))
        XCTAssertThrowsError(try [TestModel](data: jsonData, skipInvalid: true))
    }
    
    func testNonArrayData() {
        // Setup
        let jsonString = """
        {"id": 1, "name": "Item 1"}
        """
        let jsonData = jsonString.data(using: .utf8)!
        
        // Action and verification
        XCTAssertThrowsError(try [TestModel](data: jsonData))
        XCTAssertThrowsError(try [TestModel](data: jsonData, skipInvalid: true))
    }
}
