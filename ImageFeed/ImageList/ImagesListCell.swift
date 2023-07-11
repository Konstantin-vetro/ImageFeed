//
//  ImageListCell.swift
//  ImageFeed
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

public final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    @IBOutlet private weak var cellImage: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var dateLabel: UILabel!
    
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setupCell(from photo: Photo) {
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
        
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
        
        setIsLiked(isLiked: photo.isLiked)
    }
    
    func setIsLiked(isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "likeButtonOnActive") : UIImage(named: "likeButtonIsNotActive")
        likeButton.setImage(likeImage, for: .normal)
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
}

