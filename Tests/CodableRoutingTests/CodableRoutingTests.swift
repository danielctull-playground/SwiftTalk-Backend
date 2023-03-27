
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

    func test() throws {
        XCTAssertEqual(try encode(Route.home), "/home")
        XCTAssertEqual(try encode(Route.profile(5)), "/profile/5")
        XCTAssertEqual(try encode(Route.nested(.foo)), "/nested/foo")
        XCTAssertEqual(try encode(Route.nested(nil)), "/nested")
    }
}
