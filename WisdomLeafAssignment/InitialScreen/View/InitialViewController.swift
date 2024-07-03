import UIKit

// MARK: - InitialViewController
class InitialViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel = InitialScreenViewModel()
    private var refreshControl = UIRefreshControl()
    
    // MARK: - Outlets
    @IBOutlet weak var photoCollectionTableView: UITableView!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
        viewModel.fetchPhotos { _ in
            self.reloadTableView()
        }
    }
    
    // MARK: - Setup Methods
    private func setupTableView() {
        photoCollectionTableView.dataSource = self
        photoCollectionTableView.delegate = self
        photoCollectionTableView.register(PhotoCollectionTableViewCell.self, forCellReuseIdentifier: "PhotoCollectionTableViewCell")
        photoCollectionTableView.estimatedRowHeight = UITableView.automaticDimension
        photoCollectionTableView.rowHeight = UITableView.automaticDimension
        
        // Add refresh control to table view
        refreshControl.addTarget(self, action: #selector(refreshTableViewData), for: .valueChanged)
        photoCollectionTableView.refreshControl = refreshControl
    }
    
    private func bindViewModel() {
        viewModel.onPhotosFetched = { [weak self] in
            self?.reloadTableView()
        }
    }
    
    // MARK: - Actions
    @objc func refreshTableViewData() {
        viewModel.fetchPhotos { [weak self] success in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                if success {
                    self?.photoCollectionTableView.reloadData()
                } else {
                    // Handle the error accordingly
                }
            }
        }
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.photoCollectionTableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource
extension InitialViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCollectionTableViewCell", for: indexPath) as? PhotoCollectionTableViewCell else {
            return UITableViewCell()
        }
        
        let photo = viewModel.photos[indexPath.row]
        cell.index = indexPath.row
        cell.selectionStyle = .none
        cell.checkMarkCallback = checkBoxSelected
        cell.configureCheckMark(isSelected: photo.checkMark ?? false)
        
        // Configure cell with cached image
        cell.mainImageView.image = nil
        viewModel.getImage(for: photo.downloadURL) { image in
            cell.mainImageView.image = image
        }
        
        cell.configure(with: photo)
        return cell
    }
    
    func checkBoxSelected(index: Int) {
        viewModel.toggleCheckMark(at: index)
        if let cell = self.photoCollectionTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? PhotoCollectionTableViewCell {
            cell.configureCheckMark(isSelected: viewModel.photos[index].checkMark ?? false)
        }
    }
}

// MARK: - UITableViewDelegate
extension InitialViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.photos.count - 1 && viewModel.page < 10 {
            viewModel.page += 1
            viewModel.fetchPhotos { [weak self] success in
                guard let self = self else { return }
                let indexPaths = (indexPath.row..<self.viewModel.photos.count - 1).map { IndexPath(row: $0, section: 0) }
                DispatchQueue.main.async {
                    tableView.insertRows(at: indexPaths, with: .automatic)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.photos[indexPath.row].checkMark ?? false {
            showAlert(title: "Description", message: """
                ID: \(viewModel.photos[indexPath.row].id)
                Author: \(viewModel.photos[indexPath.row].author)
                Dimensions: \(viewModel.photos[indexPath.row].height)x\(viewModel.photos[indexPath.row].width)
                URL: \(viewModel.photos[indexPath.row].url)
            """, style: .actionSheet)
        } else {
            showAlert(title: "Alert", message: "Please select checkmark first", style: .alert)
        }
    }
    
    private func showAlert(title: String, message: String, style: UIAlertController.Style) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true)
    }
}
