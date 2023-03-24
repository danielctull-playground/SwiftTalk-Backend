
import Foundation

public protocol Rule {
    associatedtype R: Rule
    @RuleBuilder var rules: R { get async throws }
}

extension Rule {

    public func run(environment: EnvironmentValues) async throws -> Response? {
        if let builtin = self as? BuiltinRule {
            return try await builtin.execute(environment: environment)
        } else {
            install(environment: environment, on: self)
            return try await rules.run(environment: environment)
        }
    }
}

func install<Target>(environment: EnvironmentValues, on target: Target) {
    let mirror = Mirror(reflecting: target)
    for child in mirror.children {
        if let property = child.value as? DynamicProperty {
            property.install(environment)
        }
    }
}
