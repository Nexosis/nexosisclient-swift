public struct Column : Equatable, CustomStringConvertible {
    
    var name = ""
    var type: DataType?
    var role: Role?
    var imputation: Imputation?
    var aggregation: Aggregation?
    
    init(name: String, type: DataType? = nil, role: Role? = nil, imputation: Imputation? = nil, aggregation: Aggregation? = nil) {
        self.name = name
        self.type = type
        self.role = role
        self.imputation = imputation
        self.aggregation = aggregation
    }
    
    init(name: String, properties: [String: Any]) {
        self.name = name
        self.type = parseEnum(from: properties, withKey: "dataType")
        self.role = parseEnum(from: properties, withKey: "role")
        self.imputation = parseEnum(from: properties, withKey: "imputation")
        self.aggregation = parseEnum(from: properties, withKey: "aggregation")
    }
    
    public static func == (lhs: Column, rhs: Column) -> Bool {
        return lhs.name == rhs.name &&
            lhs.type == rhs.type &&
            lhs.role == rhs.role &&
            lhs.imputation == rhs.imputation &&
            lhs.aggregation == rhs.aggregation
    }
    
    public var description: String {
        return "Column: \(name) type=\(type as DataType?) role=\(role as Role?) imputation=\(imputation as Imputation?) aggregation=\(aggregation as Aggregation?)"
    }
    
    private func parseEnum<E: RawRepresentable>(from properties: [String: Any], withKey key: String) -> E? where E.RawValue == String {
        return E(rawValue: properties[key] as? String ?? "")
    }
}

public enum DataType: String {
    case string, numeric, logical, date, numericMeasure
}

public enum Role: String {
    case none, timestamp, target, feature, key
}

public enum Imputation: String {
    case zeroes, mean, median, mode, min, max
}

public enum Aggregation: String {
    case sum, mean, median, mode, min, max
}
