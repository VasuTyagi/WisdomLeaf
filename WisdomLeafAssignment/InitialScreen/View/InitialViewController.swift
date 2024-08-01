import UIKit

// MARK: - InitialViewController
class InitialViewController: UIViewController {
    private let viewModel = InitialScreenViewModel()
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        self.setUpUI()
        self.viewModel.delegate = self
        setupViewModel()
    }
    
    // MARK: - Setup Methods
    private func setupTableView() {
        self.movieCollectionView.dataSource = self
        self.movieCollectionView.delegate = self
        self.movieCollectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCollectionViewCell")
    }
    
    private func setUpUI() {
        if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField {
            searchTextField.backgroundColor = .darkGray
            searchTextField.textColor = .white
        }
    }
    
    private func setupViewModel() {
        viewModel.fetchPhotos { response in
            switch response {
            case .success(let data) :
                print(data)
                DispatchQueue.main.async {
                    self.movieCollectionView.reloadData()
                }
            case .failure(let error) :
                print(error)
            }
        }
    }
}

// MARK: - COLLECTIONVIEW DATASOURCE AND DELEGATE METHODS

extension InitialViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 32, height: 450)
    }
}

extension InitialViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        var movie = viewModel.movie[indexPath.item]
        if viewModel.favIds.contains(movie.imdbID ?? "") {
            movie.isFavorite = true
        }
        cell.configure(movie: movie)
        cell.favoriteButton.tag = indexPath.item
        cell.callBack = viewModel.performFavoriteButton
        if let imageData = movie.movieImage {
            cell.moviePoster.image = imageData
        } else {
            self.viewModel.fetchImage(for: indexPath.row) { [
                weak cell] image
                in DispatchQueue
                    .main.async {
                        cell?.moviePoster?.image = image
                        cell?.setNeedsLayout()
                    }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailMovie = storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else { return }
        let vm = viewModel.movie[indexPath.row]
        detailMovie.movieDetail = vm
        self.navigationController?.pushViewController(detailMovie, animated: true)
    }
}

// MARK: - Delegation Pattern For Reload

extension InitialViewController: initialViewDelegate {
    func reloadTableView() {
        DispatchQueue.main.async {
            self.movieCollectionView.reloadData()
        }
    }
}
