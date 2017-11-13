public struct Property : Equatable, CustomStringConvertible {
    
    public var name: String
    public var value: String

    public var asString: String? {
        return value
    }

    public var asDouble: Double? {
        return Double(value)
    }

    public var asBool: Bool? {
        let trues = ["true", "1", "on", "yes"]
        let falses = ["false", "0", "off", "no"]
        let lowerValue = value.lowercased()

        switch (trues.contains(lowerValue), falses.contains(lowerValue)) {
        case (true, false): return true
        case (false, true): return false
        case (_, _): return nil
        }
    }

    public init(name: String, value: String) {
        self.name = name
        self.value = value
    }

    public init(name: String, value: Double) {
        self.name = name
        self.value = value.description
    }

    public init(name: String, value: Bool) {
        self.name = name
        self.value = value.description
    }

    public static func == (lhs: Property, rhs: Property) -> Bool {
        return lhs.name == rhs.name && lhs.value == rhs.value
    }
    
    public var description: String {
        return "Property: \(name)=\(value)"
    }
}
