//
//  ImageListCell.swift
//  ImageFeed
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    @IBOutlet private weak var cellImage: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var dateLabel: UILabel!
    
    func setupCell(from photo: Photo) {
        let url = URL(string: photo.thumbImageURL)
        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "ImagePlaceholder")) { result in
                switch result {
                case .success(let image):
                    self.cellImage.contentMode = .scaleToFill
                    self.cellImage.image = image.image
                case .failure(let error):
                    print("Error loading image: \(error)")
                    self.cellImage.image = UIImage(named: "ImagePlaceholder")
                }
            }
        
        dateLabel.text = dateFormatter.string(from: photo.createdAt ?? Date())
        
        let likeImage = photo.isLiked ? UIImage(named: "likeButtonOnActive") : UIImage(named: "likeButtonIsNotActive")
        likeButton.setImage(likeImage, for: .normal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
}

