//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Максим белов on 13.10.2023.
//

import Foundation

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {

    static var isShowing: Bool = false

    private static var window: UIWindow? {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first
            else {
                return nil
            }
            return window
        }
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
