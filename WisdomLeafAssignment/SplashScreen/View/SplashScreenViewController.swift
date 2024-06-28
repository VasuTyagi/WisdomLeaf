import UIKit

// MARK: - SplashScreenViewController

class SplashScreenViewController: UIViewController {

    // MARK: - Properties
    
    private let viewModel = SplashScreenViewModel()
    
    // MARK: - @IBOutlets
    
    @IBOutlet weak var splashScreenImageView: UIImageView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the view
        setupView()
        
        // Bind ViewModel
        bindViewModel()
        
        // Start the delay
        viewModel.startDelay()
    }
    
    // MARK: - Methods
    
    private func setupView() {
        splashScreenImageView.image = UIImage(named: "wisdomLeafLogo")
    }
    
    private func bindViewModel() {
        viewModel.onTransition = { [weak self] in
            self?.showInitialViewController()
        }
    }
    
    private func showInitialViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "InitialViewController") 
        initialViewController.modalPresentationStyle = .fullScreen
        initialViewController.modalTransitionStyle = .flipHorizontal
        self.present(initialViewController, animated: true, completion: nil)
    }
}

