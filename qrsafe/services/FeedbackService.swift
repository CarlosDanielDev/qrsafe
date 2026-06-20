import AudioToolbox
import UIKit

protocol FeedbackPoviding {
    func success()
    func warning()
    func error()
}


@MainActor
final class FeedbackService: FeedbackPoviding {
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
