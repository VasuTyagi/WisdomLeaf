import UIKit

class MovieDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var imagePoster: UIImageView!
    @IBOutlet weak var ratedBackgroundView: UIView!
    @IBOutlet weak var ratedLabel: UILabel!
    @IBOutlet weak var languageBackgroundView: UIView!
    @IBOutlet weak var languageLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
      
    }
    
    func configureCell(movieDetails: MovieDetail?) {
        self.selectionStyle = .none
        self.ratedBackgroundView.layer.cornerRadius = 8
        self.ratedBackgroundView.layer.borderColor = UIColor.darkGray.cgColor
        self.ratedBackgroundView.layer.borderWidth = 1
        self.languageBackgroundView.layer.cornerRadius = 8
        self.languageBackgroundView.layer.borderColor = UIColor.darkGray.cgColor
        self.languageBackgroundView.layer.borderWidth = 1
        self.imagePoster.image = movieDetails?.movieImage
        self.ratedLabel.text = movieDetails?.rated
        self.languageLabel.text = movieDetails?.language
    }
    
}
