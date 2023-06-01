//
//  CustomCollectionViewCell.swift
//  imgurApp
//
//  Created by Petar Popovski on 19.5.23.
//

import UIKit
import QuartzCore

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var cellImageView: UIImageView!
    
    static let identifier = "CustomCollectionViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellImageView()
        
        cellImageView = UIImageView(frame: contentView.bounds)
        cellImageView.contentMode = .scaleAspectFill
        cellImageView.clipsToBounds = true
        contentView.addSubview(cellImageView)
                
        cellImageView.layer.cornerRadius = 20
    }
    
    override func awakeFromNib() {
            super.awakeFromNib()
            
            layer.cornerRadius = 8
            layer.masksToBounds = true
            layer.borderWidth = 1
        layer.borderColor = UIColor(named: "imgurGreen")?.cgColor
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 5, height: 5)
            layer.shadowRadius = 4
            layer.shadowOpacity = 1
            layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
            layer.shouldRasterize = true
            layer.rasterizationScale = UIScreen.main.scale
        }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCellImageView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cellImageView.frame = contentView.bounds
    }

    private func setupCellImageView() {
        cellImageView = UIImageView(frame: contentView.bounds)
        cellImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        contentView.addSubview(cellImageView)
    }
}
