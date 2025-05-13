import XCTest
@testable import CodableAdvance

final class EncodableArrayDataTests: XCTestCase {
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
    
    func testEncodedDataWithDefaultEncoder() throws {
        // Setup
        let array = testArray
        
        // Action
        let encodedData = try array.encodedData()
        
        // Verification - decode the data back and verify
        let decodedArray = try JSONDecoder().decode([TestModel].self, from: encodedData)
        XCTAssertEqual(decodedArray.count, array.count)
        XCTAssertEqual(decodedArray, array)
    }
    
    func testEncodedDataWithCustomEncoder() throws {
        // Setup
        let array = testArray
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        // Action
        let encodedData = try array.encodedData(encoder: encoder)
        
        // Verification
        let decodedArray = try JSONDecoder().decode([TestModel].self, from: encodedData)
        XCTAssertEqual(decodedArray, array)
        
        // Additional verification: pretty printed JSON should contain newlines
        let jsonString = String(data: encodedData, encoding: .utf8)
        XCTAssertNotNil(jsonString)
        XCTAssertTrue(jsonString?.contains("\n") ?? false)
    }
    
    func testEncodedEmptyArray() throws {
        // Setup
        let emptyArray: [TestModel] = []
        
        // Action
        let encodedData = try emptyArray.encodedData()
        
        // Verification
        let decodedArray = try JSONDecoder().decode([TestModel].self, from: encodedData)
        XCTAssertTrue(decodedArray.isEmpty)
    }
}
