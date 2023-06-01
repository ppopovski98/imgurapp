//
//  DetailViewController.swift
//  imgurApp
//
//  Created by Petar Popovski on 22.5.23.
//

import UIKit
import QuartzCore

protocol DetailScreenViewControllerDelegate: AnyObject {
    func didTapLikeButton(likesCount: Int)
}

class DetailScreenViewController: UIViewController, PixabayManagerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var deslikeButton: UIButton!
    @IBOutlet var likeCountLabel: UILabel!
    
    var imageEnlarged: UIImage?
    var isLiked = false
    var isDesliked = false
    var image: [Hit] = []
    var likeCount = 0
    var selectedImage: Hit?
    weak var delegate: DetailScreenViewControllerDelegate?
    
    var pixabayManager = PixabayManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        imageView.image = imageEnlarged
        pixabayManager.delegate = self
        
        if let selectedImage = selectedImage {
            pixabayManager.fetchImage(imageName: selectedImage.largeImageURL)
        } else {
            likeCount = 0
            likeCountLabel.text = "\(likeCount)"
        }
    }
    
    
    
    func configUI() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = UIColor(named: "imgurGreen")?.cgColor
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        if !isLiked {
            likeCount += 1
            likeCountLabel.text = "\(likeCount)"
            isLiked = true
        }
    }
    
    
    @IBAction func deslikeButtonPressed(_ sender: Any) {
        if !isDesliked {
            likeCount -= 1
            likeCountLabel.text = "\(likeCount)"
            isDesliked = true
        }
    }
    
    func didUpdateImage(_ pixabayManager: PixabayManager, image: [Hit]) {
        DispatchQueue.main.async {
            if let selectedImage = self.selectedImage {
                if let hit = image.first(where: { $0.id == selectedImage.id }) {
                    self.likeCount = hit.likes ?? 0
                } else {
                    self.likeCount = 0
                }
            } else {
                self.likeCount = 0
            }
            self.likeCountLabel.text = "\(self.likeCount)"
        }
    }
    
    
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//Darko help me!!!
