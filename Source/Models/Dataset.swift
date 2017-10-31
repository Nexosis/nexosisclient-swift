public struct Dataset {
    
    var name: String = ""
    var columns: [String: Column] = [:]
    var rows: [[String: Property]] = []

    init(name: String, columns: [Column] = [], rows: [[Property]] = []) {
        self.name = name
        columns.forEach { addColumn(column: $0) }
        rows.forEach { addRow(row: $0) }
    }
    
    init(data: [String: Any]) {
        self.name = data["dataSetName"] as? String ?? ""
        self.columns = mapColumnsFromJson(columns: data["columns"] as? [String: Any] ?? [:])
        self.rows = mapDataFromJson(data: data["data"] as? [[String:Any]] ?? [])
    }

    public mutating func addColumn(column: Column) {
        self.columns[column.name] = column
    }

    public mutating func addRow(row: [Property]) {
        var newRow: [String: Property] = [:]
        row.forEach { newRow[$0.name] = $0 }
        self.rows.append(newRow)
    }

    public var asJson: [String : Any] {
        var json: [String : Any] = [:]

        if (!columns.isEmpty) {
            var columnsJson: [String : Any] = [:]
            for (key, value) in columns { columnsJson[key] = value.asJson }
            json["columns"] = columnsJson as Any
        }

        if (!rows.isEmpty) {
            var dataJson: [[String : Any]] = []
            for (row) in rows {
                var rowJson: [String : Any] = [:]
                for (key, value) in row { rowJson[key] = value.value }
                dataJson.append(rowJson)
            }
            json["data"] = dataJson as Any
        }

        return json
    }

    private func mapColumnsFromJson(columns: [String: Any]) -> [String: Column] {
        var mappedColumns: [String: Column] = [:]
        for (key, value) in columns {
            let properties = value as? [String: Any] ?? [:]
            mappedColumns[key] = Column(name: key, properties: properties)
        }
        return mappedColumns
    }
    
    private func mapDataFromJson(data: [[String: Any]]) -> [[String: Property]] {
        return data.map { row in
            var newRow: [String: Property] = [:]
            for (key, value) in row {
                newRow[key] = Property(name: key, value: value as? String ?? "")
            }
            return newRow
        }
    }
}
