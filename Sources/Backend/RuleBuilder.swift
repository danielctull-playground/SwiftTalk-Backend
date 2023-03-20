
@resultBuilder
public enum RuleBuilder {

//    public static func buildExpression(_ expression: some Rule) -> some Rule {
//        expression
//    }
//
//    public static func buildExpression(_ expression: some ToData) -> some Rule {
//        Response(body: expression.toData)
//    }

    public static func buildEither<A: Rule, B: Rule>(first component: A) -> Either<A, B> {
        Either(component)
    }

    public static func buildEither<A: Rule, B: Rule>(second component: B) -> Either<A, B> {
        Either(component)
    }

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

    public static func buildOptional<R: Rule>(_ component: R?) -> R? {
        component
    }
}

public struct Either<A: Rule, B: Rule>: BuiltinRule, Rule {

    private let kind: Kind
    private enum Kind {
        case a(A)
        case b(B)
    }

    init(_ a: A) { kind = .a(a) }
    init(_ b: B) { kind = .b(b) }

    func execute(environment: EnvironmentValues) -> Response? {
        switch kind {
        case .a(let a): return a.run(environment: environment)
        case .b(let b): return b.run(environment: environment)
        }
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

extension Optional: Rule, BuiltinRule where Wrapped: Rule {

    func execute(environment: EnvironmentValues) -> Response? {
        self?.run(environment: environment)
    }
}
