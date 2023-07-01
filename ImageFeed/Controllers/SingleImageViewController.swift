//
//  SingleImageViewController.swift
//  ImageFeed
//

import UIKit

final class SingleImageViewController: UIViewController {
    var image: URL? {
        didSet {
            guard isViewLoaded else { return }
            loadAndShowImage(url: image)
        }
    }
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
// MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        loadAndShowImage(url: image)
    }
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
// MARK: - Load and Show Image
    private func loadAndShowImage(url: URL?) {
        guard let url = url else { return }
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: url) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure(let error):
                print(error.localizedDescription)
                //                     self.showError(url: url)
            }
        }
    }
    
// MARK: - Shared
    @IBAction private func didTapShareButton() {
        let share = UIActivityViewController(
            activityItems: [image as Any],
            applicationActivities: nil)
        share.overrideUserInterfaceStyle = .dark
        present(share, animated: true, completion: nil)
    }
    
// MARK: - Rescale Algorithm
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
// MARK: - StatusBar
        override var preferredStatusBarStyle: UIStatusBarStyle {
            .lightContent
        }
}

// MARK: - ScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
