import UIKit

// MARK: - InitialViewController
class InitialViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel = InitialScreenViewModel()
    
    // MARK: - Outlets
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        self.viewModel.delegate = self
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
    
    // MARK: - Setup Methods
    private func setupTableView() {
        self.movieCollectionView.dataSource = self
        self.movieCollectionView.delegate = self
        self.movieCollectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCollectionViewCell")
    }
}

// MARK: - UITableViewDataSource
//extension InitialViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.movie.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell else {
//            return UITableViewCell()
//        }
//        
//        let movie = viewModel.movie[indexPath.row]
//        cell.configure(movie: movie)
//        return cell
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//}

// MARK: - UITableViewDelegate
//extension InitialViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let detailMovie = storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else { return }
//        let vm = viewModel.movie[indexPath.row]
//        self.navigationController?.pushViewController(detailMovie, animated: true)
//    }
//}
extension InitialViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 32, height: 250)
    }
    
}

extension InitialViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as? MovieCollectionViewCell else {
                    return UICollectionViewCell()
                }
                let movie = viewModel.movie[indexPath.row]
                cell.configure(movie: movie)
                return cell
    }
    
    
}

extension InitialViewController: initialViewDelegate {
    func reloadTableView() {
        DispatchQueue.main.async {
            self.movieCollectionView.reloadData()
        }
    }
    
    
}
