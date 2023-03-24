
extension Rule {

    public func path(_ component: String) -> some Rule {
        modifier(Path(expectedComponent: component))
    }
}

private struct Path: RuleModifier {

    let expectedComponent: String

    func rules(content: Content) -> some Rule {
        PathReader { component in
            if component == expectedComponent {
                content
            }
        }
    }
}
