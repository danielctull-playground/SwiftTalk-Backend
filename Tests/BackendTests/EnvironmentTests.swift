
import Backend
import XCTest

struct GreetingKey: EnvironmentKey {
    static var defaultValue = "Hello"
}

extension EnvironmentValues {

    var greeting: String {
        get { self[GreetingKey.self] }
        set { self[GreetingKey.self] = newValue }
    }
}

struct Greeting: Rule {

    @Environment(\.greeting) var greeting
    var rules: some Rule {
        greeting
    }
}

struct Home: Rule {

    var rules: some Rule {
        Greeting().path("greeting")
    }
}

final class EnvironmentTests: XCTestCase {

    func testUsers() {
        XCTAssertEqual(
            Greeting().run(environment: EnvironmentValues(request: Request(path: "/"))),
            Response(body: "Hello".toData))

        XCTAssertEqual(
            Greeting().environment(\.greeting, "Hi").run(environment: EnvironmentValues(request: Request(path: "/"))),
            Response(body: "Hi".toData))

        XCTAssertEqual(
            Home().run(environment: EnvironmentValues(request: Request(path: "/greeting"))),
            Response(body: "Hello".toData))

        XCTAssertEqual(
            Home().environment(\.greeting, "Hi").run(environment: EnvironmentValues(request: Request(path: "/greeting"))),
            Response(body: "Hi".toData))
    }
}
