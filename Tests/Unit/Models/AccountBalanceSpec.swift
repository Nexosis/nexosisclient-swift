import Quick
import Nimble

@testable import NexosisApiClientiOS

class AccountBalanceSpec: QuickSpec {
    override func spec() {
        describe("AccountBalance") {
            
            var subject: AccountBalance!
            
            context("when created with an empty string") {
                
                beforeEach {
                    subject = AccountBalance(data: "")
                }
                
                it("has an amount of 0.00") {
                    expect(subject.amount).to(equal(0.00));
                }
                
                it("has a currency of empty string") {
                    expect(subject.currency).to(equal(""));
                }
            }
            
            context("when created with a valid string") {
                
                beforeEach {
                    subject = AccountBalance(data: "12345.67 USD")
                }
                
                it("has an amount of 0.00") {
                    expect(subject.amount).to(equal(12345.67));
                }
                
                it("has a currency of empty string") {
                    expect(subject.currency).to(equal("USD"));
                }
            }
        }
    }
}
