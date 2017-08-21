public struct DatasetSummary {

  var name: String = ""
  var columns: [Column] = []

  init(data: [String: Any]) {
    self.name = data["dataSetName"] as? String ?? ""
    self.columns = mapColumns(columns: data["columns"] as? [String: Any] ?? [:])
  }

  private func mapColumns(columns: [String: Any]) -> [Column] {

    var mappedColumns: [Column] = []
    for (key, value) in columns {
      let properties = value as? [String: Any] ?? [:]
      mappedColumns.append(Column(name: key, properties: properties))
    }

    return mappedColumns.sorted { $0.name < $1.name }
  }
}

public struct Column {

  var name = ""
  var type: DataType?
  var role: Role?
  var imputation: Imputation?
  var aggregation: Aggregation?

  init(name: String, properties: [String: Any]) {
    self.name = name
    self.type = parseEnum(from: properties, withKey: "dataType")
    self.role = parseEnum(from: properties, withKey: "role")
    self.imputation = parseEnum(from: properties, withKey: "imputation")
    self.aggregation = parseEnum(from: properties, withKey: "aggregation")
  }

  private func parseEnum<E: RawRepresentable>(from properties: [String: Any], withKey key: String) -> E? where E.RawValue == String {
    return E(rawValue: properties[key] as? String ?? "")
  }
}

public enum DataType: String {
  case string, numeric, logical, date, numericMeasure
}

public enum Role: String {
  case none, timestamp, target, feature
}

public enum Imputation: String {
  case zeroes, mean, median, mode
}

public enum Aggregation: String {
  case sum, mean, median, mode
}


