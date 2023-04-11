
import CodableRouting
import XCTest

enum Route: Codable, Hashable {
    case home
    case profile(Int)
    case nested(NestedRoute?)
}

enum NestedRoute: Codable, Hashable {
    case foo
}

final class CodableRoutingTests: XCTestCase {

    func testEncode() throws {
        XCTAssertEqual(try encode(Route.home), "/home")
        XCTAssertEqual(try encode(Route.profile(5)), "/profile/5")
        XCTAssertEqual(try encode(Route.nested(.foo)), "/nested/foo")
        XCTAssertEqual(try encode(Route.nested(nil)), "/nested")
    }

    func testDecode() throws {
        XCTAssertEqual(try decode("/home"), Route.home)
        XCTAssertEqual(try decode("/profile/5"), Route.profile(5))
        XCTAssertEqual(try decode("/nested/foo"), Route.nested(.foo))
        XCTAssertEqual(try decode("/nested"), Route.nested(nil))
    }
}
