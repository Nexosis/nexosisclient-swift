public struct AccountBalance : Equatable, CustomStringConvertible {
    
    public var amount: Double
    public var currency: String
    
    init(data: String) {
        let parts = data.components(separatedBy: " ")
        self.amount = Double(parts.first ?? "") ?? 0.0
        self.currency = parts.last ?? ""
    }
    
    public static func == (lhs: AccountBalance, rhs: AccountBalance) -> Bool {
        return lhs.amount == rhs.amount && lhs.currency == rhs.currency
    }
    
    public var description: String {
        return "AccountBalance: \(amount) \(currency)"
    }
}
