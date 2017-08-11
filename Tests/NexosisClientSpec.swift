import Quick
import Nimble

@testable import NexosisApiClientiOS

class NexosisClientSpec: QuickSpec {
  override func spec() {
    describe("NexosisClientApi") {

      var subject: NexosisClient!

      context("when created") {

        beforeEach {
          subject = NexosisClient(apiKey: "f3f040dfa88a4180a33ba16e1090242b", baseUrl: "https://api.uat.nexosisdev.com/v1")
        }

        describe("fetch account balance") {

          var accountBalance: AccountBalance!

          beforeEach {
            let expectation = self.expectation(description: "Alamofire")
            subject.fetchAccountBalance { balance in
              expectation.fulfill()
              accountBalance = balance
            }

            self.waitForExpectations(timeout: 10.0, handler: nil)
          }

          it("fetches the account balance") {
            expect(accountBalance.amount).to(equal(100041.09))
          }

          it("fetches the currency type") {
            expect(accountBalance.currency).to(equal("USD"))
          }

        }

      }
    }
  }
}
