
@resultBuilder
public enum RuleBuilder {

//    public static func buildExpression(_ expression: some Rule) -> some Rule {
//        expression
//    }
//
//    public static func buildExpression(_ expression: some ToData) -> some Rule {
//        Response(body: expression.toData)
//    }

    public static func buildPartialBlock(first: some ToData) -> some Rule {
        Response(body: first.toData)
    }

    public static func buildPartialBlock(accumulated: some Rule, next: some ToData) -> some Rule {
        Pair(a: accumulated, b: Response(body: next.toData))
    }

    public static func buildPartialBlock(first: some Rule) -> some Rule {
        first
    }

    public static func buildPartialBlock(accumulated: some Rule, next: some Rule) -> some Rule {
        Pair(a: accumulated, b: next)
    }
}

struct Pair<A: Rule, B: Rule>: BuiltinRule, Rule {

    let a: A
    let b: B

    func execute(environment: EnvironmentValues) -> Response? {
        if let response = a.run(environment: environment) {
            return response
        }
        return b.run(environment: environment)
    }
}
