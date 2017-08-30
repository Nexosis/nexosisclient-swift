import Quick
import Nimble

@testable import NexosisApiClientiOS

class DatasetSummarySpec: QuickSpec {
  override func spec() {
    describe("DatasetSummary") {

      var subject: DatasetSummary!

      context("when created") {

        beforeEach {
          subject = DatasetSummary(data: [
            "dataSetName" : "Sasquatch",
            "columns" : [
              "alpha" : [:],
              "brave" : [:],
              "charlie" : [:]
            ]
          ])
        }

        it("has expected name") {
          expect(subject.name).to(equal("Sasquatch"))
        }

        it("has expected columns") {
          expect(subject.columns).to(haveCount(3))
          expect(subject.columns[0].name).to(equal("alpha"))
          expect(subject.columns[1].name).to(equal("brave"))
          expect(subject.columns[2].name).to(equal("charlie"))
        }
      }
    }
  }
}
