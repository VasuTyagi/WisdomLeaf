import Foundation
import UIKit

// MARK: - InitialScreenViewModel
class InitialScreenViewModel {
    // MARK: - Properties
    var page = 1
    var photos: [Photo] = []
    var onPhotosFetched: (() -> Void)?
    private var imageCache = NSCache<NSString, UIImage>()
    private var activeDownloads: Set<URL> = []

    // MARK: - Methods
    func fetchPhotos(completion: @escaping (Bool) -> Void) {
        let urlString = "https://picsum.photos/v2/list?page=\(page)&limit=20"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Failed to fetch photos:", error)
                completion(false)
                return
            }

            guard let data = data else {
                completion(false)
                return
            }

            do {
                let photos = try JSONDecoder().decode([Photo].self, from: data)
                self?.photos.append(contentsOf: photos)
                completion(true)
                self?.onPhotosFetched?()
            } catch {
                print("Failed to decode JSON:", error)
                completion(false)
            }
        }.resume()
    }

    func getImage(for imageUrl: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: NSString(string: imageUrl)) {
            DispatchQueue.main.async {
                completion(cachedImage)
            }
            return
        }

        guard let url = URL(string: imageUrl) else {
            completion(nil)
            return
        }

        if activeDownloads.contains(url) { return }
        activeDownloads.insert(url)

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error loading images from URL: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            guard let data = data, let downloadedImage = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            DispatchQueue.main.async {
                self?.imageCache.setObject(downloadedImage, forKey: NSString(string: imageUrl))
                self?.activeDownloads.remove(url)
                completion(downloadedImage)
            }
        }.resume()
    }

    func toggleCheckMark(at index: Int) {
        if !(photos[index].checkMark ?? false) {
            photos[index].checkMark = true
        }else  {
            photos[index].checkMark = false
        }
    }
}

