public struct Dataset {

  var name: String = ""
  var columns: [String: Column] = [:]
  var data: [Event] = []

  init(data: [String: Any]) {
    self.name = data["dataSetName"] as? String ?? ""
    self.columns = mapColumns(columns: data["columns"] as? [String: Any] ?? [:])
    self.data = mapData(data: data["data"] as? [[String:Any]] ?? [])
  }

  private func mapColumns(columns: [String: Any]) -> [String: Column] {

    var mappedColumns: [String: Column] = [:]
    for (key, value) in columns {
      let properties = value as? [String: Any] ?? [:]
      mappedColumns[key] = Column(name: key, properties: properties)
    }

    return mappedColumns
  }

  private func mapData(data: [[String: Any]]) -> [Event] {
    return data.map { mapRow(row: $0) }
  }

  private func mapRow(row: [String: Any]) -> Event {

    var event: Event = [:]
    for (key, value) in row {
      let valueAsString = value as? String ?? ""
      let type = self.columns[key]?.type ?? .string

      event[key] = mapProperty(name: key, value: valueAsString, type: type)
    }

    return event
  }

  private func mapProperty(name: String, value: String, type: DataType) -> Any {
    switch type {
      case .string: return Property<String>(name: name, value: value, type: type)
      case .numeric: return Property<Double>(name: name, value: value, type: type)
      case .logical: return Property<Bool>(name: name, value: value, type: type)
      case .date: return Property<String>(name: name, value: value, type: type)
      case .numericMeasure: return Property<Double>(name: name, value: value, type: type)
    }
  }
}

public typealias Event = [String: Any]
