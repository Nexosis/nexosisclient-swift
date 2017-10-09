import Quick
import Nimble

@testable import NexosisApiClientiOS

class NexosisClientErrorSpec: QuickSpec {
    override func spec() {
        describe("NexosisClientError") {
            
            var subject: NexosisClientError!
            
            context("when created") {
                
                beforeEach {
                    subject = NexosisClientError(data: [
                        "statusCode": 400,
                        "message": "Request is invalid",
                        "errorType": "RequestValidation",
                        "errorDetails": [
                            "someProperty": "someValue",
                            "someNumber": 1234
                        ]
                        ])
                }
                
                it("has expected status code") {
                    expect(subject.statusCode).to(equal(400));
                }
                
                it("has expected message") {
                    expect(subject.message).to(equal("Request is invalid"));
                }
                
                it("has expected error type") {
                    expect(subject.errorType).to(equal("RequestValidation"));
                }
                
                it("has expected error details") {
                    expect(subject.errorDetails["someProperty"] as? String).to(equal("someValue"));
                    expect(subject.errorDetails["someNumber"] as? Int).to(equal(1234));
                }
            }
        }
    }
}
