import XCTest
@testable import CodableAdvance

final class KeyedDecodingContainerCompactMapTests: XCTestCase {
    
    // Test structures
    struct Person: Codable, Equatable {
        let name: String
        let age: Int
        
        static func == (lhs: Person, rhs: Person) -> Bool {
            return lhs.name == rhs.name && lhs.age == lhs.age
        }
    }
    
    struct Team: Decodable {
        let members: [Person]
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            members = try container
                .decode(
                    CompactDecodableArray<Person>.self,
                    forKey: .members
                ).elements
        }
        
        enum CodingKeys: String, CodingKey {
            case members
        }
    }
    
    // MARK: - Tests for compactDecode
    
    func testDecodeCompactMap() throws {
        // Given JSON with both valid and invalid elements
        let jsonData = """
        {
            "members": [
                {
                    "name": "John Doe",
                    "age": 30
                },
                {
                    "name": "Jane Smith",
                    "age": "twenty-five"
                },
                {
                    "name": "Bob Johnson",
                    "age": 40
                }
            ]
        }
        """.data(using: .utf8)!
        
        // When decoding with compactDecode
        let team = try JSONDecoder().decode(Team.self, from: jsonData)
        
        // Then only valid elements should be included
        XCTAssertEqual(team.members.count, 2)
        XCTAssertEqual(team.members[0].name, "John Doe")
        XCTAssertEqual(team.members[0].age, 30)
        XCTAssertEqual(team.members[1].name, "Bob Johnson")
        XCTAssertEqual(team.members[1].age, 40)
    }
    
    func testDecodeCompactMapWithEmptyArray() throws {
        // Given JSON with an empty array
        let jsonData = """
        {
            "members": []
        }
        """.data(using: .utf8)!
        
        // When decoding with compactDecode
        let team = try JSONDecoder().decode(Team.self, from: jsonData)
        
        // Then the array should be empty
        XCTAssertEqual(team.members.count, 0)
    }
        
    func testDecodeMixedTypeArray() throws {
        // Given JSON with mixed types in array
        let jsonData = """
        {
            "members": [
                {
                    "name": "John Doe",
                    "age": 30
                },
                "Not a person object",
                {
                    "name": "Bob Johnson",
                    "age": 40
                }
            ]
        }
        """.data(using: .utf8)!
        
        // When decoding with compactDecode
        let team = try JSONDecoder().decode(Team.self, from: jsonData)
        
        // Then only valid elements should be included
        XCTAssertEqual(team.members.count, 2)
        XCTAssertEqual(team.members[0].name, "John Doe")
        XCTAssertEqual(team.members[1].name, "Bob Johnson")
    }
}
