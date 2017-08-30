import Quick
import Nimble

@testable import NexosisApiClientiOS

class ColumnDescriptionSpec: QuickSpec {
  override func spec() {
    describe("ColumnDescription") {

      var subject: ColumnDescription!

      context("when created with a name and no properties") {

        beforeEach {
          subject = ColumnDescription(name: "cryptidType", properties: [:])
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
      }

      context("when created with a name and properties") {

        beforeEach {
          subject = ColumnDescription(
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
      }

      context("when created woth a name and properties that are invalid strings") {

        beforeEach {
          subject = ColumnDescription(
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
      }
    }
  }
}
