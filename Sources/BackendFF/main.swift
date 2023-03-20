
import Backend
import FlyingFox
import Foundation

let server = HTTPServer(port: 8002) { request in
    let path = request.path
    let body = Data(path.utf8)
    return HTTPResponse(statusCode: .ok, body: body)
}

try await server.start()
