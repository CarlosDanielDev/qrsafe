import Combine

@MainActor
final class ScanCounterModel: ObservableObject {
    @Published var displayCount: Int = 0
    
    func refresh(from counter: ScanCounter) async {
        displayCount = await counter.total
    }
}
