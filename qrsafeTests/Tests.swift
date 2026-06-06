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

struct ScanCounterTests {

    @Test func recordScanConcurrentlyWithoutLosingUpdate() async {
        let counter = ScanCounter()
        await withTaskGroup(of: Void.self) { group in
            for _ in 0..<1000 {
                group.addTask { await counter.record() }
            }
            
        }
        
        #expect(await counter.total == 1000)
    }

    @MainActor
    @Test func modelMirrorCounterTotal() async {
        let counter = ScanCounter()
        await counter.record()
        await counter.record()
        let model = ScanCounterModel()
        await model.refresh(from: counter)
        #expect(model.displayCount == 2)
    }
}
