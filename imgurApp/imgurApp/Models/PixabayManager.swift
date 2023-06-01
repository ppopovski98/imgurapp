//
//  SpotifyManager.swift
//  imgurApp
//
//  Created by Petar Popovski on 17.5.23.
//

import Foundation

protocol PixabayManagerDelegate {
    func didUpdateImage(_ pixabayManager: PixabayManager, image: [Hit])
    func didFailWithError(error: Error)
}

struct PixabayManager {
    let pixabayURL = "https://pixabay.com/api/?key=36521216-40858dfcbd732de8e4219a436&"
    
    var delegate: PixabayManagerDelegate?
    
    func fetchImage(imageName: String) {
        let urString = "\(pixabayURL)q=\(imageName)&image_type=photo"
                makeApiCall(with: urString)
            }

    
    func makeApiCall(with urlString: String) {
            if let url = URL(string: urlString) {
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: url) { data, response, error in
                    if let error = error {
                        self.delegate?.didFailWithError(error: error)
                        return
                    }

                    if let data = data {
                        do {
                            let decodedData = try JSONDecoder().decode(PixabayData.self, from: data)
                            self.delegate?.didUpdateImage(self, image: decodedData.hits)
                        } catch {
                            self.delegate?.didFailWithError(error: error)
                        }
                    }
                }
                task.resume()
            }
        }


    
    func getLikesCountForImage(with imageID: Int, completion: @escaping (Int) -> Void) {
        let likesURLString = "\(pixabayURL)key=36521216-40858dfcbd732de8e4219a436&id=\(imageID)"
        guard let likesURL = URL(string: likesURLString) else {
            completion(0)
            return
        }
        
        let task = URLSession.shared.dataTask(with: likesURL) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion(0)
                return
            }
            
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(PixabayData.self, from: data)
                    let hit = decodedData.hits.first(where: { $0.id == imageID })
                    if let likesData = hit?.likes {
                        completion(likesData)
                    } else {
                        completion(0)
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                    completion(0)
                }
            }
        }
        
        task.resume()
    }
    
    func parseJSON(_ imageData: Data) -> PixabayData? {
        let decoder = JSONDecoder()

            do {
                let decodedData = try decoder.decode(PixabayData.self, from: imageData)
                return decodedData
            } catch {
                delegate?.didFailWithError(error: error)
                return nil
            }
    }
}
