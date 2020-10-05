//
//  ViewNotesViewController.swift
//  Zoho Notes
//
//  Created by Subendran on 02/10/20.
//  Copyright © 2020 Subendran. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Markup
import SDWebImage


class ViewNotesViewController: UIViewController,NVActivityIndicatorViewable {
    //label for title
    @IBOutlet var titleLabel: UILabel!
    //label for notes
    @IBOutlet var notesLabel : UITextView!
    //Label for date
    @IBOutlet var date : UILabel!
    //image view top constraint
    @IBOutlet weak var imageViewTopConstraints: NSLayoutConstraint!
    //image view height constraint
    @IBOutlet weak var immageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewPickedImage: UIImageView!
    //view moddel for this controller
    var viewModel : ViewNotesViewModel?
    
    //MARK:- View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.notesLabel.backgroundColor = .black
        if let viewModel = self.viewModel , let model = self.viewModel?.model {
            self.setUpView(notesData: model[viewModel.selectedIndex])
        }
    }
    //MARK:- Setup view
    func setUpView(notesData:NotesData) {
        if let viewModel = self.viewModel {
            self.titleLabel.text = notesData.title
            let notes = viewModel.replaceUrl(notesData: notesData)
            
            let renderer = MarkupRenderer(baseFont: .systemFont(ofSize: 16))
            let attributedText = renderer.render(text: notes)
            
            let linkedText = NSMutableAttributedString(attributedString: attributedText)
            
            let hyperlinked = linkedText.setAsLink(textToFind: viewModel.urlButtonName, linkURL: viewModel.url)
            
            if hyperlinked {
                self.notesLabel.attributedText = NSAttributedString(attributedString: linkedText)
            } else {
                self.notesLabel.attributedText = attributedText
            }
            self.notesLabel.dataDetectorTypes = UIDataDetectorTypes.all
            
            self.notesLabel.textColor = UIColor.lightGray
            notesLabel.linkTextAttributes = [
                .foregroundColor: UIColor.gray,
                .underlineStyle: NSNumber(value: true)
            ]
            
            if notesData.image == "" {
                self.imageViewTopConstraints.constant = 0
                self.immageViewHeightConstraint.constant = 0
            } else {
                self.imageViewTopConstraints.constant = 10
                self.immageViewHeightConstraint.constant = 125
                if notesData.image.contains("https") {
                    self.imageViewPickedImage.sd_setImage(with: URL(string: notesData.image))
                } else {
                    self.imageViewPickedImage.image = notesData.image.toImage()
                    
                }
                viewModel.imageSelected = notesData.image
            }
            
            self.date.text = notesData.date
            imageViewPickedImage.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(imageClicked))
            imageViewPickedImage.addGestureRecognizer(tap)
        }
    }
    
    //MARK:- action for image click
    @objc func imageClicked() {
        
        guard let vc = storyboard?.instantiateViewController(identifier: "ViewImageViewController") as? ViewImageViewController else {
            return
        }
        vc.modalPresentationStyle = .custom
        self.viewModel?.getImageArrayWithIndex()
        vc.viewModel = viewModel?.createViewImageviewModel()
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK:- swipe gestire for view
    @IBAction func swipeAction(_ sender: UISwipeGestureRecognizer)  {
        if let viewModel = self.viewModel , let model = self.viewModel?.model{
            
            if sender.direction == .right {
                if viewModel.selectedIndex > 0 {
                    viewModel.selectedIndex = viewModel.selectedIndex - 1
                    let notes = model[viewModel.selectedIndex]
                    self.setUpView(notesData: notes)
                }
                
                
            } else {
                if viewModel.selectedIndex < viewModel.model!.count - 1 {
                    viewModel.selectedIndex = viewModel.selectedIndex + 1
                    
                    let notes = model[viewModel.selectedIndex]
                    self.setUpView(notesData: notes)
                }
            }
        }
    }
}

extension NSMutableAttributedString {
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            
            self.addAttribute(.link, value: linkURL, range: foundRange)
            
            return true
        }
        return false
    }
}

