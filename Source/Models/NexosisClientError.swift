public class NexosisClientError: Error {
    
    var statusCode: Int?
    var message: String
    var errorType: String
    var errorDetails: [String: Any]
    
    init(data: [String: Any]) {
        statusCode = data["statusCode"] as? Int
        message = data["message"] as? String ?? ""
        errorType = data["errorType"] as? String ?? ""
        errorDetails = data["errorDetails"] as? [String: Any] ?? [:]
    }
    
}
