import Testing

@testable import qrsafe

struct CheckerTests {
    @Test func defaultNameDerivesFromType() {
        #expect(AlwaysTypeSafe().name == "AlwaysTypeSafe")
    }
    
    @Test func alawaysSafeCheckerPasses() {
        #expect(AlwaysTypeSafe().check(.URL) == true)
    }
}

struct StringURLTests {
    @Test func httpsIsLikelyURL() {
        #expect("https://google.com".isLikelyURL == true)
    }
    
    @Test func normalTextIsNotURL() {
        #expect("Hello World".isLikelyURL == false)
    }
}
