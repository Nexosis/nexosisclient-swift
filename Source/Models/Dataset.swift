public struct Dataset {

  var name: String = ""
  var columns: [String: Column] = [:]
  var data: [String] = []

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

  private func mapData(data: [[String: Any]]) -> [String] {
    return data.map { row in "" }
  }
}
