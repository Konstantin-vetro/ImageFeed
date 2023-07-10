//
//  ImagesListPresenter.swift
//  ImageFeed
//

import Foundation

public protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photosCount: Int { get }
    func getPhotoIndex(_ index: Int) -> Photo?
    func viewDidLoad()
    func updateTableView()
    func willDisplay(_ indexPath: Int)
    func imageListCellDidTapLike(_ index: Int, _ cell: ImagesListCell)
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    
    private var photos: [Photo] = []
    private let imagesListService: ImagesListServiceProtocol
    
    
    init(imagesListService: ImagesListServiceProtocol = ImagesListService.shared) {
        self.imagesListService = imagesListService
    }
    
    func viewDidLoad() {
        imagesListService.fetchPhotosNextPage()
    }
    
    var photosCount: Int {
        photos.count
    }
    
    func updateTableView() {
        updateTableViewAnimated()
    }
    
    func getPhotoIndex(_ index: Int) -> Photo? {
        photos[index]
    }
    
    func willDisplay(_ indexPath: Int) {
        if indexPath + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        
        photos = imagesListService.photos
        if oldCount != newCount {
            view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
        }
    }
    
    func imageListCellDidTapLike(_ index: Int, _ cell: ImagesListCell) {
        
        guard let photo = getPhotoIndex(index) else { return }
        
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                cell.setIsLiked(isLiked: self.photos[index].isLiked)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
