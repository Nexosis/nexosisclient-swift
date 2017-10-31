import Quick
import Nimble

@testable import NexosisApiClientiOS

class DatasetSpec: QuickSpec {
    override func spec() {
        describe("Dataset") {
            
            var subject: Dataset!

            let expectedColumns = [
                "alpha": Column(name: "alpha", type: .string),
                "bravo": Column(name: "bravo", type: .numeric),
                "charlie": Column(name: "charlie", type: .logical)
            ]

            let expectedProperties = [
                "alpha": Property(name: "alpha", value: "foo"),
                "bravo": Property(name: "bravo", value: "1.2"),
                "charlie": Property(name: "charlie", value: "True")
            ]

            context("when created") {

                beforeEach {
                    subject = Dataset(
                        name: "Sasquatch",
                        columns: [
                            Column(name: "alpha", type: .string),
                            Column(name: "bravo", type: .numeric),
                            Column(name: "charlie", type: .logical)
                        ],
                        rows: [
                            [
                                Property(name: "alpha", value: "foo"),
                                Property(name: "bravo", value: "1.2"),
                                Property(name: "charlie", value: "True")
                            ]
                        ])
                }

                it("has expected name") {
                    expect(subject.name).to(equal("Sasquatch"))
                }

                it("has expected columns") {
                    expect(subject.columns).to(equal(expectedColumns))
                }

                it("has expected number of rows") {
                    expect(subject.rows).to(haveCount(1))
                }

                it("has expected properties in first row") {
                    expect(subject.rows.first).to(equal(expectedProperties))
                }

                it("becomes expected JSON") {
                    let actual = subject.asJson
                    expect(actual).to(haveCount(2))

                    let columns = actual["columns"] as? [String:Any] ?? [:]
                    expect(columns).to(haveCount(3))

                    let alpha = columns["alpha"] as? [String:Any] ?? [:]
                    expect(alpha).to(haveCount(1))
                    expect(alpha["dataType"] as? String).to(equal("string"))

                    let bravo = columns["bravo"] as? [String:Any] ?? [:]
                    expect(bravo).to(haveCount(1))
                    expect(bravo["dataType"] as? String).to(equal("numeric"))

                    let charlie = columns["charlie"] as? [String:Any] ?? [:]
                    expect(charlie).to(haveCount(1))
                    expect(charlie["dataType"] as? String).to(equal("logical"))

                    let data = actual["data"] as? [[String:Any]] ?? []
                    expect(data).to(haveCount(1))

                    expect(data.first).to(haveCount(3))
                    expect(data.first?["alpha"] as? String).to(equal("foo"))
                    expect(data.first?["bravo"] as? String).to(equal("1.2"))
                    expect(data.first?["charlie"] as? String).to(equal("True"))
                }

                context("when more columns are added") {

                    beforeEach {
                        subject.addColumn(column: Column(name: "delta"))
                    }

                    it("has expected number of columns") {
                        expect(subject.columns).to(haveCount(4))
                    }

                    it("has expected additional column") {
                        expect(subject.columns["delta"]).to(equal(Column(name: "delta")))
                    }
                }

                context("when more rows are added") {

                    beforeEach {
                        subject.addRow(row: [
                            Property(name: "alpha", value: "foo"),
                            Property(name: "bravo", value: "1.2"),
                            Property(name: "charlie", value: "True")
                        ])
                    }

                    it("has expected number of rows") {
                        expect(subject.rows).to(haveCount(2))
                    }

                    it("has expected properties in first row") {
                        expect(subject.rows[1]).to(equal(expectedProperties))
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
                            "charlie" : [ "dataType" : "logical" ]
                        ],
                        "data" : [
                            [
                                "alpha" : "foo",
                                "bravo" : "1.2",
                                "charlie" : "True"
                            ]
                        ]
                        ])
                }
                
                it("has expected name") {
                    expect(subject.name).to(equal("Sasquatch"))
                }
                
                it("has expected columns") {
                    expect(subject.columns).to(equal(expectedColumns))
                }
                
                it("has expected number of rows") {
                    expect(subject.rows).to(haveCount(1))
                }
                
                it("has expected properties in first row") {
                    expect(subject.rows.first).to(equal(expectedProperties))
                }
            }
        }
    }
}
