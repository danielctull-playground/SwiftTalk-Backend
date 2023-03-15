
import Backend
import XCTest

struct Profile: Rule {
    let id: Int
    var rules: some Rule {
        "User Profile \(id)"
    }
}

struct Users: Rule {
    var rules: some Rule {
        PathReader { component in
            if let id = Int(component) {
                Profile(id: id)
            } else {
                "Not found"
            }
        }
        "User Index"
    }
}

struct Root: Rule {
    var rules: some Rule {
        Users().path("users")
        "Index"
    }
}

final class BackendTests: XCTestCase {

    func testUsers() {
        XCTAssertEqual(
            Users().run(environment: EnvironmentValues(request: Request(path: "/"))),
            Response(body: "User Index".toData))

        XCTAssertEqual(
            Root().run(environment: EnvironmentValues(request: Request(path: "/"))),
            Response(body: "Index".toData))

        XCTAssertEqual(
            Root().run(environment: EnvironmentValues(request: Request(path: "/users"))),
            Response(body: "User Index".toData))

        XCTAssertEqual(
            Root().run(environment: EnvironmentValues(request: Request(path: "/users/foo"))),
            Response(body: "Not found".toData))

        XCTAssertEqual(
            Root().run(environment: EnvironmentValues(request: Request(path: "/users/1"))),
            Response(body: "User Profile 1".toData))
    }
}
