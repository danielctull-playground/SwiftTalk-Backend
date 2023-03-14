
import Foundation

public struct Response {

    public let statusCode: Int
    public let body: Data

    public init(statusCode: Int = 200, body: Data) {
        self.statusCode = statusCode
        self.body = body
    }
}

extension Response: Rule, BuiltinRule {

    func execute() -> Response? {
        self
    }
}

public protocol ToData {
    var toData: Data { get }
}

extension String: ToData {

    public var toData: Data {
        data(using: .utf8)!
    }
}
