//
//  ViewImageViewController.swift
//  Zoho Notes
//
//  Created by Subendran on 05/10/20.
//  Copyright © 2020 Subendran. All rights reserved.
//

import UIKit
import SDWebImage

class ViewImageViewController: UIViewController {
    @IBOutlet weak var displayImage: UIImageView!
    var viewModel: ViewImageViewModel?
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.displayImage.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
        setupvalues()
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
    
    //MARK:- Action for close
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Action for swipe
    @IBAction func swipeAction(_ sender: UISwipeGestureRecognizer) {
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
