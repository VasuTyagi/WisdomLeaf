import Foundation
import UIKit

protocol initialViewDelegate: AnyObject {
    func reloadTableView()
}

// MARK: - InitialScreenViewModel
class InitialScreenViewModel {
    
    var movie: [Search] = []
    weak var delegate: initialViewDelegate?
    var key : String = "saveFavourite"
    var favIds = [String]()
    var moviesCopy: [Search] = []
    
    init() {
        retrive()
    }
    
    // MARK: - Methods
    func fetchMovies(url : String,completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = url
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
                self?.movie = movies.search
                self?.moviesCopy = movies.search
                completion(.success([movies]))
                self?.delegate?.reloadTableView()
            } catch {
                print("Failed to decode JSON:", error)
            }
        }.resume()
    }
    
    func fetchMovie(url : String,completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        let urlString = url
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
                let movieDetail = try JSONDecoder().decode(MovieDetail.self, from: data)
                completion(.success(movieDetail))
            } catch {
                print("Failed to decode JSON:", error)
            }
        }.resume()
    }

    
    func fetchImage(for userIndex: Int, completion: @escaping (UIImage?) -> Void) {
        guard userIndex >= 0 && userIndex < movie.count else {
            completion(nil)
            return
        }
        let user = movie[userIndex]
        guard let url = URL(string: user.poster ?? "") else
        {return}
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                print("Error fetching image for user \(user): \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            self.movie[userIndex].movieImage = image
            completion(image)
        }
        task.resume()
    }
    
    func fetchFilter(searchString: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let url = "https://www.omdbapi.com/?apikey=242a5434&type=movie&s=\(searchString)&page=1"
        fetchMovies(url: url) { res in
            completion(res)
        }
    }
    
    func getMovieDetail(omdbId: String = "tt3896198", completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        let url = "https://www.omdbapi.com/?i=\(omdbId)&apikey=242a5434"
        fetchMovie(url: url) { res in
            completion(res)
        }
    }
    
    func performFavoriteButton(_ id: String) {
        if favIds.contains(id) {
            favIds.removeAll { favId in
                if favId == id {
                    return true
                }
                return false
            }
            saveFavourite()
            self.delegate?.reloadTableView()
            return
        }
        favIds.append(id)
        self.delegate?.reloadTableView()
        saveFavourite()
    }
    
    // MARK: - For Saving Favourite
    func saveFavourite() {
        UserDefaults.standard.set(favIds, forKey: key)
    }
    
    // MARK: - For Retrive Data
    func retrive() {
        favIds = UserDefaults.standard.array(forKey: key) as? [String] ?? []
    }
}

