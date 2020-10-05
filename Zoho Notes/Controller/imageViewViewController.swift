//
//  imageViewViewController.swift
//  Zoho Notes
//
//  Created by Subendran on 05/10/20.
//  Copyright © 2020 Subendran. All rights reserved.
//

import UIKit

class imageViewViewController: UIViewController {
    
    let displayImage : UIImageView = {
        let displayImages = UIImageView()
        displayImages.contentMode = .scaleToFill
        return displayImages
    }()
    
    let titleLabel : UILabel = {
        let title = UILabel()
        title.numberOfLines = 0
        title.font = UIFont.preferredFont(forTextStyle: .body)
        title.textAlignment = .left
        title.textColor = UIColor.white
        return title
    }()
    
    let datelabel : UILabel = {
        let date = UILabel()
        date.numberOfLines = 0
        date.font = UIFont.preferredFont(forTextStyle: .body)
        date.textAlignment = .left
        date.textColor = UIColor.darkGray

        return date
    }()
    
    let notesView : UITextView = {
        let notes = UITextView()
        notes.backgroundColor = .black
        notes.textColor = UIColor.lightGray
        notes.font = UIFont.preferredFont(forTextStyle: .footnote)

        return notes
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        self.view.addSubview(displayImage)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
