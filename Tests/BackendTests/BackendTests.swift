
import Backend
import XCTest

//struct Profile: Rule {
//    let id: UUID
//    var rules: some View {
//        "User Profile \(id)"
//    }
//}

struct Users: Rule {
    var rules: some Rule {
        PathReader { component in
            "User \(component)"
//            if let id = UUID(uuidString: component) {
//                Profile(id: id)
//            } else {
//                "Not found"
//            }
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
            Response(body: "User foo".toData))

    }
}
