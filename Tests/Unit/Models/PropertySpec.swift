import Quick
import Nimble

@testable import NexosisApiClient

class PropertySpec: QuickSpec {
    override func spec() {
        describe("Property") {

            var subject: Property!

            context("when created with a string") {
                
                beforeEach {
                    subject = Property(name: "foo", value: "bar")
                }
                
                it("has expected name") {
                    expect(subject.name).to(equal("foo"))
                }
                
                it("has expected value") {
                    expect(subject.value).to(equal("bar"))
                }

                it("parses to a string") {
                    expect(subject.asString).to(equal("bar"))
                }

                it("parses to a double") {
                    expect(subject.asDouble).to(beNil())
                }

                it("parses to a bool") {
                    expect(subject.asBool).to(beNil())
                }
            }

            context("when created with a string that is a valid number") {

                beforeEach {
                    subject = Property(name: "foo", value: "123.45")
                }

                it("parses to a string") {
                    expect(subject.asString).to(equal("123.45"))
                }

                it("parses to a double") {
                    expect(subject.asDouble).to(equal(123.45))
                }

                it("parses to a bool") {
                    expect(subject.asBool).to(beNil())
                }
            }

            context("when created with a string of 'true'") {

                beforeEach {
                    subject = Property(name: "foo", value: "true")
                }

                it("parses to a string") {
                    expect(subject.asString).to(equal("true"))
                }

                it("parses to a double") {
                    expect(subject.asDouble).to(beNil())
                }

                it("parses to a bool") {
                    expect(subject.asBool).to(beTrue())
                }
            }

            context("when created with a string of '1'") {

                beforeEach {
                    subject = Property(name: "foo", value: "1")
                }

                it("parses to a string") {
                    expect(subject.asString).to(equal("1"))
                }

                it("parses to a double") {
                    expect(subject.asDouble).to(equal(1.0))
                }

                it("parses to a bool") {
                    expect(subject.asBool).to(beTrue())
                }
            }

            context("when created with a string of 'on'") {

                beforeEach {
                    subject = Property(name: "foo", value: "on")
                }

                it("parses to a string") {
                    expect(subject.asString).to(equal("on"))
                }

                it("parses to a double") {
                    expect(subject.asDouble).to(beNil())
                }

                it("parses to a bool") {
                    expect(subject.asBool).to(beTrue())
                }
            }

            context("when created with a string of 'yes'") {

                beforeEach {
                    subject = Property(name: "foo", value: "yes")
                }

                it("parses to a string") {
                    expect(subject.asString).to(equal("yes"))
                }

                it("parses to a double") {
                    expect(subject.asDouble).to(beNil())
                }

                it("parses to a bool") {
                    expect(subject.asBool).to(beTrue())
                }
            }

            context("when created with a string of 'false'") {

                beforeEach {
                    subject = Property(name: "foo", value: "false")
                }

                it("parses to a string") {
                    expect(subject.asString).to(equal("false"))
                }

                it("parses to a double") {
                    expect(subject.asDouble).to(beNil())
                }

                it("parses to a bool") {
                    expect(subject.asBool).to(beFalse())
                }
            }

            context("when created with a string of '0'") {

                beforeEach {
                    subject = Property(name: "foo", value: "0")
                }

                it("parses to a string") {
                    expect(subject.asString).to(equal("0"))
                }

                it("parses to a double") {
                    expect(subject.asDouble).to(equal(0.0))
                }

                it("parses to a bool") {
                    expect(subject.asBool).to(beFalse())
                }
            }

            context("when created with a string of 'off'") {

                beforeEach {
                    subject = Property(name: "foo", value: "off")
                }

                it("parses to a string") {
                    expect(subject.asString).to(equal("off"))
                }

                it("parses to a double") {
                    expect(subject.asDouble).to(beNil())
                }

                it("parses to a bool") {
                    expect(subject.asBool).to(beFalse())
                }
            }

            context("when created with a string of 'no'") {

                beforeEach {
                    subject = Property(name: "foo", value: "no")
                }

                it("parses to a string") {
                    expect(subject.asString).to(equal("no"))
                }

                it("parses to a double") {
                    expect(subject.asDouble).to(beNil())
                }

                it("parses to a bool") {
                    expect(subject.asBool).to(beFalse())
                }
            }

            context("when created with a number") {

                beforeEach {
                    subject = Property(name: "foo", value: 123.45)
                }

                it("parses to a string") {
                    expect(subject.asString).to(equal("123.45"))
                }

                it("parses to a double") {
                    expect(subject.asDouble).to(equal(123.45))
                }

                it("parses to a bool") {
                    expect(subject.asBool).to(beNil())
                }
            }

            context("when created with a boolean of true") {

                beforeEach {
                    subject = Property(name: "foo", value: true)
                }

                it("parses to a string") {
                    expect(subject.asString).to(equal("true"))
                }

                it("parses to a double") {
                    expect(subject.asDouble).to(beNil())
                }

                it("parses to a bool") {
                    expect(subject.asBool).to(beTrue())
                }
            }

            context("when created with a boolean of false") {

                beforeEach {
                    subject = Property(name: "foo", value: false)
                }

                it("parses to a string") {
                    expect(subject.asString).to(equal("false"))
                }

                it("parses to a double") {
                    expect(subject.asDouble).to(beNil())
                }

                it("parses to a bool") {
                    expect(subject.asBool).to(beFalse())
                }
            }
        }
    }
}
