import Foundation

// MARK: - SplashScreenViewModel
class SplashScreenViewModel {
    
    // Delay duration
    private let delayDuration: TimeInterval = 5
    
    // Closure to notify the view controller to transition to the next screen
    var onTransition: (() -> Void)?
    
    // MARK: - Methods
    func startDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + delayDuration) {
            self.onTransition?()
        }
    }
}

