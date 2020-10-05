//
//  DisplayImageViewController.swift
//  Zoho Notes
//
//  Created by Subendran on 05/10/20.
//  Copyright © 2020 Subendran. All rights reserved.
//

import UIKit

class DisplayImageViewController: UIViewController {
    var viewModel: DisplayImageViewModel?
    
    let displayImage : UIImageView = {
        let displayImages = UIImageView()
        displayImages.contentMode = .scaleToFill
        return displayImages
    }()
    
    let closeButton : UIButton = {
        let button = UIButton(type: .close)
        button.backgroundColor = .red
        button.isEnabled = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayImage.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(displayImage)
        let swipeRight = UISwipeGestureRecognizer()
        let swipeLeft = UISwipeGestureRecognizer()
        swipeRight.direction = .right
        swipeLeft.direction = .left
        
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
        
        swipeRight.addTarget(self, action: #selector(swipeAction(sender:)))
        swipeLeft.addTarget(self, action: #selector(swipeAction(sender:)))
        
        self.closeButton.frame = CGRect(x: self.view.frame.width - 45, y: 30, width: 30, height: 30)
         closeButton.addTarget(self, action: #selector(self.closeAction), for: .touchUpInside)
        self.displayImage.addSubview(self.closeButton)
       
        
        setupvalues()
        // Do any additional setup after loading the view.
    }
    
    func setupvalues() {
        if let viewModel = self.viewModel {
            let notes = viewModel.model?[viewModel.selectedIndex]
            if (notes?.image.contains("https"))! {
                self.displayImage.sd_setImage(with: URL(string: notes?.image ?? ""))
            } else {
                self.displayImage.image = notes?.image.toImage()
            }
        }
    }
    
    @objc func closeAction() {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    //MARK:- Action for swipe
    @objc func swipeAction(sender: UISwipeGestureRecognizer) {
        if let viewModel = self.viewModel {
            if sender.direction == .right {
                
                if viewModel.selectedIndex > 0 {
                    viewModel.selectedIndex = viewModel.selectedIndex - 1
                    
                    let notes = viewModel.model?[viewModel.selectedIndex]
                    if (notes?.image.contains("https"))! {
                        self.displayImage.sd_setImage(with: URL(string: notes?.image ?? ""))
                    } else {
                        self.displayImage.image = notes?.image.toImage()
                    }
                }
            } else {
                if viewModel.selectedIndex < viewModel.model!.count - 1 {
                    viewModel.selectedIndex = viewModel.selectedIndex + 1
                    
                    let notes = viewModel.model?[viewModel.selectedIndex]
                    if (notes?.image.contains("https"))! {
                        self.displayImage.sd_setImage(with: URL(string: notes?.image ?? ""))
                    } else {
                        self.displayImage.image = notes?.image.toImage()
                    }
                }
            }
        }
    }
    
}
