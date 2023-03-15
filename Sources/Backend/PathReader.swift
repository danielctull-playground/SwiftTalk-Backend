
public struct PathReader<Content: Rule>: BuiltinRule, Rule {

    let content: (String) -> Content

    public init(@RuleBuilder content: @escaping (String) -> Content) {
        self.content = content
    }

    func execute(environment: EnvironmentValues) -> Response? {
        guard let component = environment.remainingPath.first else { return nil }
        var environment = environment
        environment.remainingPath.removeFirst()
        return content(component).run(environment: environment)
    }
}
