//
//  MainScreenViewController.swift
//  imgurApp
//
//  Created by Petar Popovski on 16.5.23.
//

import UIKit
import QuartzCore

class MainScreenViewController: UIViewController {
    
    @IBOutlet var searchTextBar: UISearchBar!
    @IBOutlet var collectionView: UICollectionView!
    
    var isSearchPerformed = false
    var pixabayManager = PixabayManager()
    var dataSource = [Hit]()
    var selectedImageID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customiseCollectionView()
        customiseSearchField()
    }
    
    func customiseCollectionView() {
        let nib = UINib(nibName: "CustomCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    func customiseSearchField() {
        searchTextBar.layer.cornerRadius = 16
        searchTextBar.barTintColor = UIColor(named: "imgurGreen")
        searchTextBar.layer.masksToBounds = true
        searchTextBar.searchTextField.backgroundColor = .clear
        
        let heightConstraint = searchTextBar.heightAnchor.constraint(equalToConstant: 50)
        
        heightConstraint.isActive = true
        
        searchTextBar.delegate = self
    }
    
    
    
}

//MARK: -

extension MainScreenViewController: PixabayManagerDelegate {
    
    func didUpdateLikeCount(_ likesCount: Int) {
        print(likesCount)
    }
    
    
    func didUpdateImage(_ pixabayManager: PixabayManager, image: [Hit]) {
        DispatchQueue.main.async {
            self.dataSource.append(contentsOf: image)
            self.collectionView.reloadData()
        }
    }
    
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: -

extension MainScreenViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchImage = searchTextBar.text {
            pixabayManager.delegate = self
            pixabayManager.fetchImage(imageName: searchImage)
        }
        searchTextBar.text = ""
        
        isSearchPerformed = true
        
        dataSource = []
        collectionView.reloadData()
    }
}

//MARK: -


extension MainScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = 160.0
        let cellHeight: CGFloat = 160.0
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let spacing: CGFloat = 10
        let edgeInsets = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        return edgeInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let enlargedImageVC = storyboard.instantiateViewController(withIdentifier: "DetailScreenViewController") as? DetailScreenViewController else {
            return
        }
        
        let navigationController = UINavigationController(rootViewController: enlargedImageVC)
        
        self.present(navigationController, animated: true, completion: nil)
        
        let selectedImage = dataSource[indexPath.row]
        
        selectedImageID = selectedImage.id
        
        pixabayManager.getLikesCountForImage(with: selectedImageID ?? 0) { likesCount in
            DispatchQueue.main.async {
                enlargedImageVC.likeCountLabel.text = "\(likesCount)"
            }
            
                enlargedImageVC.likeCount = selectedImage.likes ?? 0
                enlargedImageVC.delegate = self
            
            
            if let imageURL = URL(string: selectedImage.largeImageURL) {
            URLSession.shared.dataTask(with: imageURL) { data, _, _ in
            if let data = data {
            let image = UIImage(data: data)
                enlargedImageVC.imageEnlarged = image
                    }
                }.resume()
            }
        }
}
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let hit = dataSource[indexPath.item]
            
            if let imageURL = URL(string: hit.largeImageURL) {
                URLSession.shared.dataTask(with: imageURL) { data, _, _ in
                    if let data = data {
                        DispatchQueue.main.async {
                            let image = UIImage(data: data)
                            cell.cellImageView.image = image
                        }
                    }
                }.resume()
            }
            
            return cell
        }
    }


//MARK: -

extension MainScreenViewController: DetailScreenViewControllerDelegate {
    func didTapLikeButton(likesCount: Int) {
        if let indexPath = collectionView.indexPathsForSelectedItems?.first {
            dataSource[indexPath.item].likes = likesCount
            collectionView.reloadItems(at: [indexPath])
        }
    }
}
