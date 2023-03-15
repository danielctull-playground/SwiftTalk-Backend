
public struct Request: Equatable, Hashable {
    let path: String

    public init(path: String) {
        self.path = path
    }
}
