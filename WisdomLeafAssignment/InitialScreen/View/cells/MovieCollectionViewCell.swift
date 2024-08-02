import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    var callBack: ((String) -> Void)?
    var id : String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func favButtonTapped(_ sender: Any) {
        callBack?(self.id)
    }
    func configure(movie: Search){
        self.id = movie.imdbID 
        self.mainView.layer.cornerRadius = 15
        self.mainView.clipsToBounds = true
        self.movieTitle.text = movie.title
        self.movieReleaseDate.text = movie.year
        self.moviePoster.layer.cornerRadius = 8
        self.moviePoster.layer.shadowColor = UIColor.purple.cgColor
        self.moviePoster.layer.shadowOffset = CGSize(width: 10, height: 10)
        self.mainView.layer.cornerRadius = 8
        self.mainView.backgroundColor = .black
        
        if movie.isFavorite {
            self.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            self.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
}
