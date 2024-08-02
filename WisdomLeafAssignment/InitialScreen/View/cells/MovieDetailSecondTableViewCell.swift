import UIKit

class MovieDetailSecondTableViewCell: UITableViewCell {
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var actorLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(movieDetail: MovieDetail?) {
        if let year = movieDetail?.released, let runtime = movieDetail?.runtime {
            self.yearLabel.text = "\(year) • \(runtime)"
        }
        self.movieTitleLabel.text = movieDetail?.title
        self.genreLabel.text = movieDetail?.genre
        self.descriptionLabel.text = movieDetail?.plot
        if let actor = movieDetail?.actors {
            self.actorLabel.text = "Staff \(actor)"
        }
        if let director = movieDetail?.director {
            self.directorLabel.text = "Directed by \(director)"
        }
    }
}
