
protocol BuiltinRule {
    func execute(environment: EnvironmentValues) async throws -> Response?
}

extension BuiltinRule {

    public var rules: Never {
        fatalError()
    }
}

extension Never: Rule {

    public var rules: some Rule {
        fatalError()
    }
}
