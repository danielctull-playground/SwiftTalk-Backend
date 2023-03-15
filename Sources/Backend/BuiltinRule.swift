
protocol BuiltinRule {
    func execute(environment: EnvironmentValues) -> Response?
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
