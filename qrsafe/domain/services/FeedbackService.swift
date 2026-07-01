import AudioToolbox
import UIKit

protocol FeedbackProviding {
    func success()
    func warning()
    func error()
}


@MainActor
final class FeedbackService: FeedbackProviding {
    private let generator = UINotificationFeedbackGenerator()
    func success() {
        generator.notificationOccurred(.success)
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    func warning() {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    func error() {
        
    }
}
