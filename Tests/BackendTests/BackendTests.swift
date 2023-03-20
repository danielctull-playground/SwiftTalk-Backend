
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

    func testUsers() async throws {

        do {
            let response = try await Users().run(environment: EnvironmentValues(request: Request(path: "/")))
            XCTAssertEqual(response, Response(body: "User Index".toData))
        }

        do {
            let response = try await Root().run(environment: EnvironmentValues(request: Request(path: "/")))
            XCTAssertEqual(response, Response(body: "Index".toData))
        }

        do {
            let response = try await Root().run(environment: EnvironmentValues(request: Request(path: "/users")))
            XCTAssertEqual(response, Response(body: "User Index".toData))
        }

        do {
            let response = try await Root().run(environment: EnvironmentValues(request: Request(path: "/users/foo")))
            XCTAssertEqual(response, Response(body: "Not found".toData))
        }

        do {
            let response = try await Root().run(environment: EnvironmentValues(request: Request(path: "/users/1")))
            XCTAssertEqual(response, Response(body: "User Profile 1".toData))
        }
    }
}
