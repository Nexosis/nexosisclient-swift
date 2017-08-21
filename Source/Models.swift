public struct AccountBalance {

  init(data: String) {
    let parts = data.components(separatedBy: " ")
    self.amount = Double(parts.first ?? "") ?? 0.0
    self.currency = parts.last ?? ""
  }

  var amount: Double
  var currency: String
}

public struct DatasetSummary {

  init(data: [String: Any]) {
    self.name = data["dataSetName"] as? String ?? ""
  }

  var name: String
}
