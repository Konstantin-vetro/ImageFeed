//
//  ImagesListTests.swift
//  ImageFeedTests
//

@testable import ImageFeed
import XCTest

private let dateFormatter = ISO8601DateFormatter()
private let photo = Photo(PhotoResult(id: "test",
                                       createdAt: "2023-07-10T02:37:12",
                                       width: 100,
                                       height: 100,
                                       likedByUser: false,
                                       description: "test",
                                       urls: UrlsResult(full: "test", thumb: "test")), date: dateFormatter)

final class ImageListTests: XCTestCase {
    private final class ImageListServiceTestModel: ImagesListServiceProtocol {
        var photos: [ImageFeed.Photo] = []
        func fetchPhotosNextPage() { photos.append(photo) }
        func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {}
    }
    
    func testFetchPhotosNextPage() {
        // given
        let ImageListServiceTestModel = ImageListServiceTestModel()
        let presenter = ImagesListPresenter(imagesListService: ImageListServiceTestModel)

        // when
        presenter.viewDidLoad()

        // then
        XCTAssertTrue(ImageListServiceTestModel.photos.count == 1)
    }
    
    func testUpdateTableView() {
        // given
        let ImageListServiceTestModel = ImageListServiceTestModel()
        let view = ImageListViewControllerSpy()
        let presenter = ImagesListPresenter(imagesListService: ImageListServiceTestModel)
        presenter.view = view

        // when
        ImageListServiceTestModel.fetchPhotosNextPage()
        presenter.updateTableView()

        // then
        XCTAssertTrue(view.updateTableViewAnimatedCalled == true)
    }
    
    func testWillDisplay() {
        // given
        let ImageListServiceTestModel = ImageListServiceTestModel()
        let view = ImageListViewControllerSpy()
        let presenter = ImagesListPresenter(imagesListService: ImageListServiceTestModel)
        presenter.view = view

        // when
        ImageListServiceTestModel.fetchPhotosNextPage()
        presenter.updateTableView()
        presenter.willDisplay(0)

        // then
        XCTAssertTrue(ImageListServiceTestModel.photos.count == 2)
    }
}

final class ImageListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImageFeed.ImagesListViewControllerProtocol?
    var photosCount: Int = 0
    
    var viewDidLoadCalled = false
    var getPhotoIndexCalled = false
    var tableViewUpdatedCalled = false
    var willDisplayCalled = false
    var imageListCellDidTapLikeCalled = false
    
    func getPhotoIndex(_ index: Int) -> ImageFeed.Photo? {
        getPhotoIndexCalled = true
        return nil
    }
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func updateTableView() {
        tableViewUpdatedCalled = true
    }
    
    func willDisplay(_ indexPath: Int) {
        willDisplayCalled = true
    }
    
    func imageListCellDidTapLike(_ index: Int, _ cell: ImageFeed.ImagesListCell) {
        imageListCellDidTapLikeCalled = true
    }
}

final class ImageListViewControllerSpy : ImagesListViewControllerProtocol {
    var presenter: ImageFeed.ImagesListPresenterProtocol?
    
    var updateTableViewAnimatedCalled = false
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        updateTableViewAnimatedCalled = true
    }
}
