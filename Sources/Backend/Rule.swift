
import Foundation

public protocol Rule {
    associatedtype R: Rule
    @RuleBuilder var rules: R { get }
}

extension Rule {

    public func run() -> Response? {
        if let builtin = self as? BuiltinRule {
            return builtin.execute()
        } else {
            return rules.run()
        }
    }
}
