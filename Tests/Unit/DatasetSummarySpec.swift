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
              "a-string" : [
                "dataType": "string",
                "role": "none",
                "imputation": "zeroes",
                "aggregation": "sum"
              ],
              "b-numeric" : [
                "dataType": "numeric",
                "role": "timestamp",
                "imputation": "mean",
                "aggregation": "mean"
              ],
              "c-logical" : [
                "dataType": "logical",
                "role": "target",
                "imputation": "median",
                "aggregation": "median"
              ],
              "d-date" : [
                "dataType": "date",
                "role": "feature",
                "imputation": "mode",
                "aggregation": "mode"
              ],
              "e-measure" : [
                "dataType": "numericMeasure",
                "role": "none",
                "imputation": nil,
                "aggregation": nil
              ],
              "f-missing" : [:],
              "g-invalid" : [
                "dataType": "bad",
                "role": "bad",
                "imputation": "bad",
                "aggregation": "bad"
              ]
            ]
          ])
        }

        it("has expected name") {
          expect(subject.name).to(equal("Sasquatch"))
        }

        it("has expected number of columns") {
          expect(subject.columns).to(haveCount(7))
        }

        it("has expected column names") {
          expect(subject.columns[0].name).to(equal("a-string"))
          expect(subject.columns[1].name).to(equal("b-numeric"))
          expect(subject.columns[2].name).to(equal("c-logical"))
          expect(subject.columns[3].name).to(equal("d-date"))
          expect(subject.columns[4].name).to(equal("e-measure"))
          expect(subject.columns[5].name).to(equal("f-missing"))
          expect(subject.columns[6].name).to(equal("g-invalid"))
        }

        it("has expected column data types") {
          expect(subject.columns[0].type).to(equal(DataType.string))
          expect(subject.columns[1].type).to(equal(DataType.numeric))
          expect(subject.columns[2].type).to(equal(DataType.logical))
          expect(subject.columns[3].type).to(equal(DataType.date))
          expect(subject.columns[4].type).to(equal(DataType.numericMeasure))
        }

        it("has expected column roles") {
          expect(subject.columns[0].role).to(equal(Role.none))
          expect(subject.columns[1].role).to(equal(Role.timestamp))
          expect(subject.columns[2].role).to(equal(Role.target))
          expect(subject.columns[3].role).to(equal(Role.feature))
        }

        it("has expected column imputations") {
          expect(subject.columns[0].imputation).to(equal(Imputation.zeroes))
          expect(subject.columns[1].imputation).to(equal(Imputation.mean))
          expect(subject.columns[2].imputation).to(equal(Imputation.median))
          expect(subject.columns[3].imputation).to(equal(Imputation.mode))
        }

        it("has expected column aggregation") {
          expect(subject.columns[0].aggregation).to(equal(Aggregation.sum))
          expect(subject.columns[1].aggregation).to(equal(Aggregation.mean))
          expect(subject.columns[2].aggregation).to(equal(Aggregation.median))
          expect(subject.columns[3].aggregation).to(equal(Aggregation.mode))
        }

        it("has expected column properties when properties are missing") {
          let column: Column = subject.columns[5]

          expect(column.type).to(beNil())
          expect(column.role).to(beNil())
          expect(column.imputation).to(beNil())
          expect(column.aggregation).to(beNil())
        }

        it("has expected column properties when properties are invalid") {
          let column: Column = subject.columns[6]

          expect(column.type).to(beNil())
          expect(column.role).to(beNil())
          expect(column.imputation).to(beNil())
          expect(column.aggregation).to(beNil())
        }
      }
    }
  }
}
