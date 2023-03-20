
import Backend
import FlyingFox
import Foundation

struct User {
    let id: Int
}

func loadUser(id: Int) async throws -> User? {
    User(id: id)
}

struct Users: Rule {
    let id: Int
    var rules: some Rule {
        get async throws {
            if let user = try await loadUser(id: id) {
                "User \(user.id)"
            }
        }
    }
}

struct Home: Rule {
    var rules: some Rule {

        Users(id: 1)
            .path("users")

        "Home"
    }
}

let server = HTTPServer(port: 8002) { request in

    guard let response = try await Home().run(environment: EnvironmentValues(request: Request(path: request.path))) else {
        return HTTPResponse(statusCode: .notFound)
    }

    return HTTPResponse(statusCode: HTTPStatusCode(response.statusCode, phrase: ""), body: response.body)
}

try await server.start()
