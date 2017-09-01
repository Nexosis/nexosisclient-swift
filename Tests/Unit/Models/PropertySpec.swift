import Quick
import Nimble

@testable import NexosisApiClientiOS

class PropertySpec: QuickSpec {
  override func spec() {
    describe("Property") {

      describe(".string") {

        var subject: Property<String>!

        beforeEach {
          subject = Property(name: "foo", value: "bar", type: .string)
        }

        it("has expected name") {
          expect(subject.name).to(equal("foo"))
        }

        it("has expected value") {
          expect(subject.value).to(equal("bar"))
        }
      }

      describe(".date") {

        var subject: Property<String>!

        beforeEach {
          subject = Property(name: "foo", value: "2000-01-01T00:00:00Z", type: .date)
        }

        it("has expected value") {
          expect(subject.value).to(equal("2000-01-01T00:00:00Z"))
        }
      }
      
      describe(".numeric") {

        var subject: Property<Double>!

        beforeEach {
          subject = Property(name: "foo", value: "123.45", type: .numeric)
        }

        it("has expected value") {
          expect(subject.value).to(equal(123.45))
        }
      }

      describe(".numericMeasure") {

        var subject: Property<Double>!

        beforeEach {
          subject = Property(name: "foo", value: "123.45", type: .numericMeasure)
        }

        it("has expected value") {
          expect(subject.value).to(equal(123.45))
        }
      }
      
      describe(".logical") {

        var subject: Property<Bool>!

        describe("true conditions") {

          context("when boolean is True") {

            beforeEach {
              subject = Property(name: "foo", value: "True", type: .logical)
            }

            it("has expected value") {
              expect(subject.value).to(beTrue())
            }
          }

          context("when boolean is 1") {

            beforeEach {
              subject = Property(name: "foo", value: "1", type: .logical)
            }

            it("has expected value") {
              expect(subject.value).to(beTrue())
            }
          }

          context("when boolean is On") {

            beforeEach {
              subject = Property(name: "foo", value: "On", type: .logical)
            }

            it("has expected value") {
              expect(subject.value).to(beTrue())
            }
          }

          context("when boolean is Yes") {

            beforeEach {
              subject = Property(name: "foo", value: "Yes", type: .logical)
            }

            it("has expected value") {
              expect(subject.value).to(beTrue())
            }
          }
        }

        describe("false conditions") {

          context("when boolean is False") {

            beforeEach {
              subject = Property(name: "foo", value: "False", type: .logical)
            }

            it("has expected value") {
              expect(subject.value).to(beFalse())
            }
          }

          context("when boolean is 0") {

            beforeEach {
              subject = Property(name: "foo", value: "0", type: .logical)
            }

            it("has expected value") {
              expect(subject.value).to(beFalse())
            }
          }

          context("when boolean is Off") {

            beforeEach {
              subject = Property(name: "foo", value: "Off", type: .logical)
            }

            it("has expected value") {
              expect(subject.value).to(beFalse())
            }
          }

          context("when boolean is No") {

            beforeEach {
              subject = Property(name: "foo", value: "No", type: .logical)
            }

            it("has expected value") {
              expect(subject.value).to(beFalse())
            }
          }
        }

        context("when boolean is invalid") {

          beforeEach {
            subject = Property(name: "foo", value: "Snargle", type: .logical)
          }

          it("has expected value") {
            expect(subject.value).to(beNil())
          }
        }
      }
    }
  }
}
