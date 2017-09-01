public struct Property<T : Equatable> : Equatable, CustomStringConvertible {

  var name: String
  var type: DataType
  var value: T?

  init(name: String, value: String, type: DataType = .string) {
    self.name = name
    self.type = type
    self.value = parseValue(value: value)
  }

  private func parseValue(value: String) -> T? {
    switch self.type {
      case .string: return parseString(value)
      case .numeric: return parseDouble(value)
      case .logical: return parseBool(value)
      case .date: return parseString(value)
      case .numericMeasure: return parseDouble(value)
    }
  }

  private func parseDouble(_ value: String) -> T? {
    return Double(value) as? T
  }

  private func parseBool(_ value: String) -> T? {
    let trues = ["true", "1", "on", "yes"]
    let falses = ["false", "0", "off", "no"]
    let lowerValue = value.lowercased()

    switch (trues.contains(lowerValue), falses.contains(lowerValue)) {
      case (true, false): return true as? T
      case (false, true): return false as? T
      case (_, _): return nil
    }
  }

  private func parseString(_ value: String) -> T? {
    return value as? T
  }

  public static func == (lhs: Property, rhs: Property) -> Bool {
    return lhs.name == rhs.name && lhs.value == rhs.value
  }

  public var description: String {
    return "Property: \(name)=\(value as T?) type=\(type)"
  }
}

