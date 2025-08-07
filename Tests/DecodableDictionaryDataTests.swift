import XCTest
@testable import CodableAdvance

final class DecodableDictionaryDataTests: XCTestCase {
    enum TestKey: String, Decodable, Hashable {
        case a, b, c, d
    }

    func testInitWithValidDataStandardMode() throws {
        let json = """
        {"a": 10, "b": 20, "c": 30, "d": 40}
        """
        let data = json.data(using: .utf8)!
        let dict = try [TestKey: Int](data: data)
        XCTAssertEqual(dict, [.a: 10, .b: 20, .c: 30, .d: 40])
    }

    func testInitWithInvalidKeyStandardMode() throws {
        let json = """
        {"a": 10, "invalid": 20, "c": 30, "d": 40}
        """
        let data = json.data(using: .utf8)!
        let dict = try [TestKey: Int](data: data)
        XCTAssertEqual(dict, [.a: 10, .c: 30, .d: 40])
    }

    func testInitWithInvalidValueStandardMode() throws {
        let json = """
        {"a": 10, "b": "invalid", "c": 30, "d": 40}
        """
        let data = json.data(using: .utf8)!
        XCTAssertThrowsError(try [TestKey: Int](data: data))
    }

    func testInitWithValidDataCompactMode() throws {
        let json = """
        {"a": 10, "b": 20, "c": 30, "d": 40}
        """
        let data = json.data(using: .utf8)!
        let dict = try [TestKey: Int](data: data, compactDecode: true)
        XCTAssertEqual(dict, [.a: 10, .b: 20, .c: 30, .d: 40])
    }

    func testInitWithInvalidKeyCompactMode() throws {
        let json = """
        {"a": 10, "invalid": 20, "c": 30, "d": 40}
        """
        let data = json.data(using: .utf8)!
        let dict = try [TestKey: Int](data: data, compactDecode: true)
        XCTAssertEqual(dict, [.a: 10, .c: 30, .d: 40])
    }

    func testInitWithInvalidValueCompactMode() throws {
        let json = """
        {"a": 10, "b": "invalid", "c": 30, "d": 40}
        """
        let data = json.data(using: .utf8)!
        let dict = try [TestKey: Int](data: data, compactDecode: true)
        XCTAssertEqual(dict, [.a: 10, .c: 30, .d: 40])
    }
}
