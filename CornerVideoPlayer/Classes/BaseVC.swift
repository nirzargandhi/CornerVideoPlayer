//
//  BaseVC.swift
//  CornerVideoPlayer
//
//  Created by Nirzar Gandhi on 18/05/25.
//

import UIKit

class BaseVC: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    fileprivate var backgroundView: UIView?
    fileprivate var activityIndicator: UIActivityIndicatorView?
    
    
    // MARK: -
    // MARK: - View init Methods
    override func viewDidLoad() {
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        self.navBarConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        self.hideNavigationBottomShadow()
        
        APPDELEOBJ.navController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
    }
}


// MARK: -
// MARK: - Call Back
extension BaseVC {
    
    func navBarConfig() {
        
        // Navigation Bar configuration
        if #available(iOS 13, *) {
            
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            
            appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.white]
            
            appearance.backgroundColor = .black
            appearance.shadowColor = .black
            
            self.navigationItem.standardAppearance = appearance
            self.navigationItem.scrollEdgeAppearance = appearance
            
        } else {
            
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.white]
            UINavigationBar.appearance().tintColor = UIColor.white
            
            UINavigationBar.appearance().shadowImage = UIImage()
            UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        }
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }
    
    func showActivityIndicator() {
        
        DispatchQueue.main.async {
            
            guard let window = WINDOWSCENE?.windows.first else { return }
            
            // Avoid multiple spinners
            if self.backgroundView != nil { return }
            
            let background = UIView(frame: window.bounds)
            background.backgroundColor = UIColor(white: 0, alpha: 0.4)
            
            let indicator = UIActivityIndicatorView(style: .large)
            indicator.center = background.center
            indicator.color = .white
            indicator.startAnimating()
            
            background.addSubview(indicator)
            window.addSubview(background)
            
            self.backgroundView = background
            self.activityIndicator = indicator
        }
    }
    
    func hideActivityIndicator() {
        
        DispatchQueue.main.async {
            
            self.activityIndicator?.stopAnimating()
            self.backgroundView?.removeFromSuperview()
            
            self.backgroundView = nil
            self.activityIndicator = nil
        }
    }
}


// MARK: -
// MARK: - Button Touch & Action
extension BaseVC {
    
    // Left Bar Buttons
    @objc func back(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
}
