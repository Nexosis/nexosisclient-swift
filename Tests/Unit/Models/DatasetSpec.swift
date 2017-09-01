import Quick
import Nimble

@testable import NexosisApiClientiOS

class DatasetSpec: QuickSpec {
  override func spec() {
    describe("Dataset") {

      var subject: Dataset!

      context("when created") {

        beforeEach {
          subject = Dataset(data: [
            "dataSetName" : "Sasquatch",
            "columns" : [
              "alpha" : [ "role" : "none" ],
              "bravo" : [ "dataType" : "string" ],
              "charlie" : [:]
            ],
            "data" : [
              [
                "timestamp" : "2000-01-01T00:00:00+00:00",
                "target" : "1.2",
                "feature" : "3.4",
                "string" : "Yeti"
              ],
              [
                "timestamp" : "2001-01-01T00:00:00+00:00",
                "target" : "5.6",
                "feature" : "7.8",
                "string" : "Chupacabra"
              ],
              [
                "timestamp" : "2002-01-01T00:00:00+00:00",
                "target" : "9.1",
                "feature" : "2.3",
                "string" : "Nessie"
              ]
            ]
          ])
        }

        it("has expected name") {
          expect(subject.name).to(equal("Sasquatch"))
        }

        it("has expected columns") {
          expect(subject.columns).to(haveCount(3))
          expect(subject.columns["alpha"]).to(equal(Column(name: "alpha", role: Role.none)))
          expect(subject.columns["bravo"]).to(equal(Column(name: "bravo", type: .string)))
          expect(subject.columns["charlie"]).to(equal(Column(name: "charlie")))
        }

        it("has expected number of rows") {
          expect(subject.data).to(haveCount(3))
        }
      }
    }
  }
}
