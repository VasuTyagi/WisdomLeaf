import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(movie: Movie){
        self.movieTitle.text = movie.title
        self.movieReleaseDate.text = movie.released
        loadImage(from: movie.poster) { result in
            self.moviePoster.image = result
        }
        self.moviePoster.layer.cornerRadius = 8
        self.mainView.layer.cornerRadius = 8
        self.mainView.backgroundColor = .lightGray
    }
    
    func loadImage(from url: String?, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: url ?? "") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Handle errors or invalid data
            if let error = error {
                print("Error loading image: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Invalid image data")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            // Return the image on the main thread
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
