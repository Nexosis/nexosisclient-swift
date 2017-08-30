public struct DatasetSummary {

  var name: String = ""
  var columns: [ColumnDescription] = []

  init(data: [String: Any]) {
    self.name = data["dataSetName"] as? String ?? ""
    self.columns = mapColumns(columns: data["columns"] as? [String: Any] ?? [:])
  }

  private func mapColumns(columns: [String: Any]) -> [ColumnDescription] {

    var mappedColumns: [ColumnDescription] = []
    for (key, value) in columns {
      let properties = value as? [String: Any] ?? [:]
      mappedColumns.append(ColumnDescription(name: key, properties: properties))
    }

    return mappedColumns.sorted { $0.name < $1.name }
  }
}
