import Quick
import Nimble

@testable import NexosisApiClient

class ColumnSpec: QuickSpec {
    override func spec() {
        describe("Column") {
            
            var subject: Column!

            context("when created") {

                beforeEach {
                    subject = Column(name: "cryptidType", type: .string, role: .feature, imputation: .zeroes, aggregation: .sum)
                }

                it("has expected name") {
                    expect(subject.name).to(equal("cryptidType"))
                }

                it("leaves all other properties as nil") {
                    expect(subject.type).to(equal(DataType.string))
                    expect(subject.role).to(equal(Role.feature))
                    expect(subject.imputation).to(equal(Imputation.zeroes))
                    expect(subject.aggregation).to(equal(Aggregation.sum))
                }

                it("becomes expected JSON") {
                    let actual = subject.asJson
                    expect(actual).to(haveCount(4))
                    expect(actual["dataType"] as? String).to(equal("string"))
                    expect(actual["role"] as? String).to(equal("feature"))
                    expect(actual["imputation"] as? String).to(equal("zeroes"))
                    expect(actual["aggregation"] as? String).to(equal("sum"))
                }
            }

            context("when created with just a name") {
                
                beforeEach {
                    subject = Column(name: "cryptidType")
                }
                
                it("has expected name") {
                    expect(subject.name).to(equal("cryptidType"))
                }
                
                it("leaves all other properties as nil") {
                    expect(subject.type).to(beNil())
                    expect(subject.role).to(beNil())
                    expect(subject.imputation).to(beNil())
                    expect(subject.aggregation).to(beNil())
                }

                it("becomes expected JSON") {
                    let actual = subject.asJson
                    expect(actual).to(haveCount(0))
                }
            }
            
            context("when created with a name and JSON properties") {
                
                beforeEach {
                    subject = Column(
                        name: "cryptidType",
                        properties: [
                            "dataType": "string",
                            "role": "none",
                            "imputation": "zeroes",
                            "aggregation": "sum"
                        ]
                    )
                }
                
                it("has expected name") {
                    expect(subject.name).to(equal("cryptidType"))
                }
                
                it("parse the other strings to enums") {
                    expect(subject.type).to(equal(DataType.string))
                    expect(subject.role).to(equal(Role.none))
                    expect(subject.imputation).to(equal(Imputation.zeroes))
                    expect(subject.aggregation).to(equal(Aggregation.sum))
                }

                it("becomes expected JSON") {
                    let actual = subject.asJson
                    expect(actual).to(haveCount(4))
                    expect(actual["dataType"] as? String).to(equal("string"))
                    expect(actual["role"] as? String).to(equal("none"))
                    expect(actual["imputation"] as? String).to(equal("zeroes"))
                    expect(actual["aggregation"] as? String).to(equal("sum"))
                }
            }
            
            context("when created with a name and JSON properties that are invalid strings") {
                
                beforeEach {
                    subject = Column(
                        name: "cryptidType",
                        properties: [
                            "dataType": "bad",
                            "role": "bad",
                            "imputation": "bad",
                            "aggregation": "really bad"
                        ]
                    )
                }
                
                it("has expected name") {
                    expect(subject.name).to(equal("cryptidType"))
                }
                
                it("parse the other strings to enums") {
                    expect(subject.type).to(beNil())
                    expect(subject.role).to(beNil())
                    expect(subject.imputation).to(beNil())
                    expect(subject.aggregation).to(beNil())
                }

                it("becomes expected JSON") {
                    let actual = subject.asJson
                    expect(actual).to(haveCount(0))
                }
            }
        }
    }
}
