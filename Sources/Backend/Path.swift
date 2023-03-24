
extension Rule {

    public func path(_ component: String) -> some Rule {
        PathRule(content: self, expectedComponent: component)
    }
}

fileprivate struct PathRule<Content: Rule>: Rule {

    let content: Content
    let expectedComponent: String

    var rules: some Rule {
        PathReader { component in
            if component == expectedComponent {
                content
            }
        }
    }
}
