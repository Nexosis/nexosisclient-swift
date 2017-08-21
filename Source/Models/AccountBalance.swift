public struct AccountBalance {

  var amount: Double
  var currency: String

  init(data: String) {
    let parts = data.components(separatedBy: " ")
    self.amount = Double(parts.first ?? "") ?? 0.0
    self.currency = parts.last ?? ""
  }
}
