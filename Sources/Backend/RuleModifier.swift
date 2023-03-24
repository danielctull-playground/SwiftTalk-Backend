
public protocol RuleModifier {
    associatedtype Result: Rule

    @RuleBuilder
    func rules(content: Content) -> Result
}

public struct Content: Rule, BuiltinRule {
    private var rule: any Rule
    init(_ rule: some Rule) {
        self.rule = rule
    }

    func execute(environment: EnvironmentValues) async throws -> Response? {
        try await rule.run(environment: environment)
    }
}

extension Rule {

    public func modifier<Modifier: RuleModifier>(
        _ modifier: Modifier
    ) -> some Rule {
        Modified(content: self, modifier: modifier)
    }
}

private struct Modified<C: Rule, Modifier: RuleModifier>: Rule {

    let content: C
    let modifier: Modifier

    var rules: some Rule {
        modifier.rules(content: Content(content))
    }
}
