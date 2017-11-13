public struct NexosisClientError: Error {
    
    public var statusCode: Int?
    public var message: String
    public var errorType: String
    public var errorDetails: [String: Any]
    
    init(data: [String: Any]) {
        statusCode = data["statusCode"] as? Int
        message = data["message"] as? String ?? ""
        errorType = data["errorType"] as? String ?? ""
        errorDetails = data["errorDetails"] as? [String: Any] ?? [:]
    }
    
}
