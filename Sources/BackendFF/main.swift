
import Backend
import FlyingFox
import Foundation

struct Users: Rule {
    let id: Int
    var rules: some Rule {
        "User \(id)"
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

    guard let response = Home().run(environment: EnvironmentValues(request: Request(path: request.path))) else {
        return HTTPResponse(statusCode: .notFound)
    }

    return HTTPResponse(statusCode: HTTPStatusCode(response.statusCode, phrase: ""), body: response.body)
}

try await server.start()
