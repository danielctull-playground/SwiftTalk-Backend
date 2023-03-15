
extension Rule {

    public func path(_ component: String) -> some Rule {
        PathRule(base: self, component: component)
    }
}

fileprivate struct PathRule<Base: Rule>: BuiltinRule, Rule {

    let base: Base
    let component: String

    func execute(environment: EnvironmentValues) -> Response? {
        guard environment.remainingPath.first == component else { return nil }
        var environment = environment
        environment.remainingPath.removeFirst()
        return base.run(environment: environment)
    }
}
