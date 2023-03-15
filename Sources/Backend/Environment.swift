
import Foundation

public protocol EnvironmentKey {
    associatedtype Value
    static var defaultValue: Value { get }
}

private final class Box<Value> {
    var value: Value
    init(value: Value) {
        self.value = value
    }
}

@propertyWrapper
public struct Environment<Value>: DynamicProperty {

    let keyPath: KeyPath<EnvironmentValues, Value>
    fileprivate let box: Box<EnvironmentValues?> = Box(value: nil)

    func install(_ environment: EnvironmentValues) {
        box.value = environment
    }

    public var wrappedValue: Value {
        guard let environment = box.value else {
            fatalError("Using environment before it is set up.")
        }
        return environment[keyPath: keyPath]
    }

    public init(_ keyPath: KeyPath<EnvironmentValues, Value>) {
        self.keyPath = keyPath
    }
}



public struct EnvironmentValues {

    var request: Request
    var remainingPath: [String]
    private var values: [ObjectIdentifier: Any] = [:]

    public init(request: Request) {
        self.request = request
        remainingPath = (request.path as NSString).pathComponents
        assert(remainingPath.first == "/") // Should throw an error rather than assert.
        remainingPath.removeFirst()
    }

    public subscript<Key: EnvironmentKey>(key: Key.Type = Key.self) -> Key.Value {
        get {
            values[ObjectIdentifier(key)] as? Key.Value ?? Key.defaultValue
        }
        set {
            values[ObjectIdentifier(key)] = newValue
        }
    }
}

// MARK: - Writing to the environment

extension Rule {

    public func environment<Value>(
        _ keyPath: WritableKeyPath<EnvironmentValues, Value>,
        _ value: Value
    ) -> some Rule {
        EnvironmentWriter(content: self, keyPath: keyPath, value: value)
    }
}

struct EnvironmentWriter<Value, Content: Rule>: BuiltinRule, Rule {
    let content: Content
    let keyPath: WritableKeyPath<EnvironmentValues, Value>
    let value: Value

    func execute(environment: EnvironmentValues) -> Response? {
        var environment = environment
        environment[keyPath: keyPath] = value
        return content.run(environment: environment)
    }
}

// MARK: - Installing the environment

protocol DynamicProperty {
    func install(_ environment: EnvironmentValues)
}
