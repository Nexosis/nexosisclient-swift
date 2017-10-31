import Quick
import Nimble

@testable import NexosisApiClientiOS

class DatasetSpec: QuickSpec {
    override func spec() {
        fdescribe("Dataset") {
            
            var subject: Dataset!

            let expectedColumns = [
                "alpha": Column(name: "alpha", type: .string),
                "bravo": Column(name: "bravo", type: .numeric),
                "charlie": Column(name: "charlie", type: .logical),
                "delta": Column(name: "delta", type: .date),
                "echo": Column(name: "echo", type: .numericMeasure)
            ]

            context("when created") {

                beforeEach {
                    subject = Dataset(
                        name: "Sasquatch",
                        columns: [
                            Column(name: "alpha", type: .string),
                            Column(name: "bravo", type: .numeric),
                            Column(name: "charlie", type: .logical),
                            Column(name: "delta", type: .date),
                            Column(name: "echo", type: .numericMeasure)
                        ],
                        data: [
                            Property<String>(name: "alpha", value: "foo", type: .string)
                        ])
                }

                it("has expected name") {
                    expect(subject.name).to(equal("Sasquatch"))
                }

                it("has expected columns") {
                    expect(subject.columns).to(equal(expectedColumns))
                }

                it("has no rows") {
                    expect(subject.data).to(beEmpty())
                }

                context("when more columns are added") {

                }

                context("when more data is added") {

                    beforeEach {
                        subject.addData(data: [
                        ])
                    }

                    it("has expected rows") {

                    }
                }
            }

            context("when created from JSON") {
                
                beforeEach {
                    subject = Dataset(data: [
                        "dataSetName" : "Sasquatch",
                        "columns" : [
                            "alpha" : [ "dataType" : "string" ],
                            "bravo" : [ "dataType" : "numeric" ],
                            "charlie" : [ "dataType" : "logical" ],
                            "delta" : [ "dataType" : "date" ],
                            "echo" : [ "dataType" : "numericMeasure" ],
                        ],
                        "data" : [
                            [
                                "alpha" : "foo",
                                "bravo" : "1.2",
                                "charlie" : "True",
                                "delta" : "2013-01-04T00:00:00Z",
                                "echo" : "3.4"
                            ],
                            [:],
                            [:]
                        ]
                        ])
                }
                
                it("has expected name") {
                    expect(subject.name).to(equal("Sasquatch"))
                }
                
                it("has expected columns") {
                    expect(subject.columns).to(equal(expectedColumns))
                }
                
                it("has expected number of events") {
                    expect(subject.data).to(haveCount(3))
                }
                
                it("has expected properties in event") {
                    var event: Event = subject.data.first ?? [:]
                    expect(event).to(haveCount(5))
                    expect(event["alpha"] as? Property).to(equal(Property<String>(name: "alpha", value: "foo")))
                    expect(event["bravo"] as? Property).to(equal(Property<Double>(name: "bravo", value: "1.2", type: .numeric)))
                    expect(event["charlie"] as? Property).to(equal(Property<Bool>(name: "charlie", value: "Yes", type: .logical)))
                    expect(event["delta"] as? Property).to(equal(Property<String>(name: "delta", value: "2013-01-04T00:00:00Z", type: .date)))
                    expect(event["echo"] as? Property).to(equal(Property<Double>(name: "echo", value: "3.4", type: .numericMeasure)))
                }
            }
        }
    }
}
