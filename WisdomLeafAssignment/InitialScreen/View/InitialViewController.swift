import UIKit

// MARK: - InitialViewController
class InitialViewController: UIViewController {
    private let viewModel = InitialScreenViewModel()
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setUpUI()
        self.viewModel.delegate = self
        self.setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpUI()
    }
    
    // MARK: - Setup Methods
    private func setupTableView() {
        self.movieCollectionView.backgroundColor = .clear
        self.movieCollectionView.dataSource = self
        self.movieCollectionView.delegate = self
        self.movieCollectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCollectionViewCell")
    }
    
    private func setUpUI() {
        if let searchTextField = self.searchBar.value(forKey: "searchField") as? UITextField {
            searchTextField.backgroundColor = .clear
            searchTextField.textColor = .white
        }
        self.title = "Movies"
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 18)
        ]
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = #colorLiteral(red: 0.09411764706, green: 0.09411764706, blue: 0.09411764706, alpha: 1)
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 18)
        ]
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.scrollEdgeAppearance = appearance
            navigationBar.standardAppearance = appearance
            navigationBar.tintColor = .white
        }
        self.searchBar.delegate = self
        self.searchBar.showsCancelButton = true
    }
    
    private func setupViewModel() {
        viewModel.fetchFilter(searchString: "Guard") { response in
            switch response {
            case .success(let data) :
                DispatchQueue.main.async {
                    self.movieCollectionView.reloadData()
                }
            case .failure(let error) :
                print(error)
            }
        }
    }
    
    private func filterMovies(searchText: String) {
        if searchText.isEmpty {
            self.setupViewModel()
            return
        }
        self.viewModel.fetchFilter(searchString: searchText) { response in
            switch response {
            case .success(let data) :
                DispatchQueue.main.async {
                    self.movieCollectionView.reloadData()
                }
            case .failure(let error) :
                print(error)
            }
        }
    }
}

// MARK: - COLLECTIONVIEW DelegateFlowLayout

extension InitialViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 32, height: 450)
    }
}

// MARK: - CollectionView Datasource and Dalegate

extension InitialViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        var movie = viewModel.movie[indexPath.item]
        if self.viewModel.favIds.contains(movie.imdbID ?? "") {
            movie.isFavorite = true
        }
        cell.configure(movie: movie)
        cell.favoriteButton.tag = indexPath.item
        cell.callBack = self.viewModel.performFavoriteButton
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
        let vm = self.viewModel.movie[indexPath.row]
        self.viewModel.getMovieDetail(omdbId: vm.imdbID) { res in
            switch res{
            case .success(let movieDetail):
                DispatchQueue.main.async {
                    detailMovie.movieDetail = movieDetail
                    detailMovie.movieDetail?.movieImage = vm.movieImage
                    self.navigationController?.pushViewController(detailMovie, animated: true)
                }
            case .failure(_):
                break
            }
        }
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

// MARK: - SearchBar Delegate Methods

extension InitialViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterMovies(searchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
