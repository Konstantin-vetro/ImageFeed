//
//  ViewController.swift
//  ImageFeed
//

import UIKit

public protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    func updateTableViewAnimated(oldCount: Int, newCount: Int)
}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol? = {
        return ImagesListPresenter()
    }()
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var imagesListServiceObserver: NSObjectProtocol?
    
    @IBOutlet private var tableView: UITableView!
    
// MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.view = self
        setupTableView()
        setupNotifications()
        presenter?.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? SingleImageViewController,
           let indexPath = sender as? IndexPath,
           segue.identifier == showSingleImageSegueIdentifier {
            guard let photo = presenter?.getPhotoIndex(indexPath.row)?.largeImageURL, let largeImageURL = URL(string: photo) else { return }
            
            viewController.image = largeImageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
// MARK: - TableView
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: ImagesListCell.reuseIdentifier,
                                 bundle: nil),
                                 forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
// MARK: - Setup Notifications
    private func setupNotifications() {
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.presenter?.updateTableView()
            }
    }
    
// MARK: - Animated TableView
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        tableView.performBatchUpdates {
            let indexPaths = (oldCount ..< newCount).map { rowValue in
                IndexPath(row: rowValue, section: 0)
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
    
// MARK: - StatusBar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: - TableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let photosCount = presenter?.photosCount else { return 0 }
        return photosCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else { return UITableViewCell() }
        
        imageListCell.delegate = self
        
        setupCell(imageListCell, indexPath)
        return imageListCell
    }
    
    private func setupCell(_ cell: ImagesListCell, _ indexPath: IndexPath) {
        guard let photo = presenter?.getPhotoIndex(indexPath.row) else { return }
        cell.setupCell(from: photo)
    }
}

// MARK: - TableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.willDisplay(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photo = presenter?.getPhotoIndex(indexPath.row)?.size else { return CGFloat() }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        UIBlockingProgressHUD.show()
        presenter?.imageListCellDidTapLike(indexPath.row, cell)
        UIBlockingProgressHUD.dismiss()
    }
}
