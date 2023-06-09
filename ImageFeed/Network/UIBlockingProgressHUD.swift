//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    let shared = UIBlockingProgressHUD()
    private static var window: UIWindow? {
        UIApplication.shared.windows.first
    }
    
    static func show() {
        DispatchQueue.main.async {
            window?.isUserInteractionEnabled = false
            ProgressHUD.show()
        }
    }
    static func dismiss() {
        DispatchQueue.main.async {
            window?.isUserInteractionEnabled = true
            ProgressHUD.dismiss()
        }
    }
    
    static func setupAnimation() {
        ProgressHUD.colorAnimation = .ypBlack
    }
}
