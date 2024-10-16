//
//  UIViewController+Extensions.swift
//  CyptoCoins
//
//  Created by K Gopi on 16/10/24.
//

import UIKit



extension UIViewController {

    func setNavigationAppearance() {
        if #available(iOS 15, *) {
            // MARK: Navigation bar appearance
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            navigationBarAppearance.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : UIColor.white
            ]
            let offset = UIOffset(horizontal: -CGFloat.greatestFiniteMagnitude, vertical: 0)
            navigationBarAppearance.titlePositionAdjustment = offset
            navigationBarAppearance.backgroundColor = Utility.appThemeColor
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        }
    }

    // Function to show activity indicator
    @discardableResult
    func showActivityIndicator(onView: UIView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = onView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.tintColor = Utility.appThemeColor
        activityIndicator.startAnimating()
        onView.addSubview(activityIndicator)

        // Optionally, add constraints to make it stay centered in the view
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: onView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: onView.centerYAnchor)
        ])

        return activityIndicator
    }

    // Function to remove activity indicator
    func removeActivityIndicator(_ activityIndicator: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
}
