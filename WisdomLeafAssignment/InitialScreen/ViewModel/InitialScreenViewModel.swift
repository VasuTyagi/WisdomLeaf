import Foundation
import UIKit

protocol initialViewDelegate: AnyObject {
    func reloadTableView()
}

// MARK: - InitialScreenViewModel
class InitialScreenViewModel {
    
    var movie: [Movie] = []
    weak var delegate: initialViewDelegate?

    // MARK: - Methods
    func fetchPhotos(completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "https://www.omdbapi.com/?i=tt3896198&apikey=242a5434"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Failed to fetch photos:", error)
                return
            }

            guard let data = data else {
                return
            }
            do {
                let movies = try JSONDecoder().decode(Movie.self, from: data)
                self?.movie = [movies]
                completion(.success([movies]))
                self?.delegate?.reloadTableView()
            } catch {
                print("Failed to decode JSON:", error)
            }
        }.resume()
    }
}

