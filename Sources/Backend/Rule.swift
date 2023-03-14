
import Foundation

public protocol Rule {
    associatedtype R: Rule
    @RuleBuilder var rules: R { get }
}
