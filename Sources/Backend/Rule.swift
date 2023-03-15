
import Foundation

public protocol Rule {
    associatedtype R: Rule
    @RuleBuilder var rules: R { get }
}

extension Rule {

    public func run(environment: EnvironmentValues) -> Response? {
        if let builtin = self as? BuiltinRule {
            return builtin.execute(environment: environment)
        } else {
            let mirror = Mirror(reflecting: self)
            for child in mirror.children {
                if let property = child.value as? DynamicProperty {
                    property.install(environment)
                }
            }
            return rules.run(environment: environment)
        }
    }
}
