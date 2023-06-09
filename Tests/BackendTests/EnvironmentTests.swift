
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

struct GreetingModifier: RuleModifier {

    @Environment(\.greeting) var greeting

    func rules(content: Content) -> some Rule {
        content.environment(\.greeting, "\(greeting) modified")
    }
}

final class EnvironmentTests: XCTestCase {

    func testUsers() async throws {

        do {
            let response = try await Greeting().run(environment: EnvironmentValues(request: Request(path: "/")))
            XCTAssertEqual(response, Response(body: "Hello".toData))
        }

        do {
            let response = try await Greeting().environment(\.greeting, "Hi").run(environment: EnvironmentValues(request: Request(path: "/")))
            XCTAssertEqual(response, Response(body: "Hi".toData))
        }

        do {
            let response = try await Home().run(environment: EnvironmentValues(request: Request(path: "/greeting")))
            XCTAssertEqual(response, Response(body: "Hello".toData))
        }

        do {
            let response = try await Home().environment(\.greeting, "Hi").run(environment: EnvironmentValues(request: Request(path: "/greeting")))
            XCTAssertEqual(response, Response(body: "Hi".toData))
        }
    }

    func testRuleModifier() async throws {
        let rule = Greeting()
            .modifier(GreetingModifier())
            .environment(\.greeting, "Good day")
        let response = try await rule.run(environment: EnvironmentValues(request: Request(path: "/")))
        XCTAssertEqual(response, Response(body: "Good day modified".toData))
    }
}
