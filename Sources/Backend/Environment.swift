
import Foundation

public struct EnvironmentValues {
    var request: Request
    var remainingPath: [String]

    public init(request: Request) {
        self.request = request
        remainingPath = (request.path as NSString).pathComponents
        assert(remainingPath.first == "/") // Should throw an error rather than assert.
        remainingPath.removeFirst()
    }
}
