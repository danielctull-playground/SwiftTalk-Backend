
public struct EnvironmentValues {
    var request: Request
    var remainingPath: [String]

    public init(request: Request) {
        self.request = request
        assert(request.path.first == "/") // Should throw an error rather than assert.
        self.remainingPath = request.path.dropFirst().components(separatedBy: "/")
    }
}
