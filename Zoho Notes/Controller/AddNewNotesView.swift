//
//  AddNewNotesView.swift
//  Zoho Notes
//
//  Created by Subendran on 02/10/20.
//  Copyright © 2020 Subendran. All rights reserved.
//

import UIKit
import Photos

class AddNewNotesView: UIViewController,UITextViewDelegate, UIImagePickerControllerDelegate ,UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var notesTextView: UITextView!
    @IBOutlet weak var attachmentImage: UIImageView!
    var picker:UIImagePickerController?=UIImagePickerController()
    @IBOutlet weak var imageViewHeighrConstraints: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    public var completion: ((NotesData)-> Void)?
    var notesData = NotesData()
    let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didSaveTapped))
    let attachmentButton = UIBarButtonItem(title: "Picture", style: .done, target: self, action: #selector(didAttachmentTapped))
    
    //MARK:- view life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.picker?.delegate = self
        self.view.backgroundColor = .black
        self.titleTextField.backgroundColor = .black
        self.notesTextView.backgroundColor = .black
        self.notesTextView.delegate = self
        self.titleTextField.delegate = self
        self.notesTextView.text = "Type Something..."
        notesTextView.textColor = UIColor.lightGray
        titleTextField.becomeFirstResponder() 
        self.attachmentButton.tintColor = .darkGray
        self.saveButton.tintColor = .darkGray
        navigationItem.rightBarButtonItems = [saveButton,attachmentButton]
        self.imageViewHeighrConstraints.constant = 0
        self.imageViewTopConstraint.constant = 0
    }
    
    //MARK:- Textfield and textview Delegates
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"
        {
            view.endEditing(true)
            return false
        }
        else
        {
            return true
        }
    }
    
    //MARK:- Action for attach
    @objc func didAttachmentTapped() {
        let photo = PHPhotoLibrary.authorizationStatus()
        if photo == .notDetermined {
            PHPhotoLibrary.requestAuthorization({ status in
                if status == .authorized {
                    self.openGallary()
                }
            })
            
        } else {
            self.openGallary()
        }
    }
    
    //MARK:- Open photos
    func openGallary() {
        self.titleTextField.resignFirstResponder()
        DispatchQueue.main.async {
            
            self.picker!.allowsEditing = false
            self.picker!.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(self.picker!, animated: true, completion: nil)
        }
    }
    
    @objc func didSaveTapped() {
        if let title = titleTextField.text , !title.isEmpty, let notes = notesTextView.text, !notes.isEmpty {
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd,YYYY"
            let formattedDate = formatter.string(from: date)
            print(formattedDate)
            self.notesData.title = title
            self.notesData.notes = notes
            self.notesData.image = self.attachmentImage.image?.toString() ?? ""
            self.notesData.date = formattedDate
            completion?(self.notesData)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage =  UIImage.from(info: info)
        self.attachmentImage.image = chosenImage
        self.attachmentButton.tintColor = .green
        self.imageViewHeighrConstraints.constant = 125
        self.imageViewTopConstraint.constant = 10
        dismiss(animated: true, completion: nil)
    }
}

extension UIImage {
    static func from(info: [UIImagePickerController.InfoKey : Any]) -> UIImage? {
        if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
            return image
        }
        
        var imageToBeReturned: UIImage?
        if let url = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.referenceURL.rawValue)] as? URL,
            let asset = PHAsset.fetchAssets(withALAssetURLs: [url], options: nil).firstObject {
            let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            option.isSynchronous = true
            manager.requestImage(for: asset, targetSize: CGSize(width: 1000, height: 1000), contentMode: .aspectFit, options: option, resultHandler: {(image: UIImage?, info: [AnyHashable : Any]?) in
                imageToBeReturned = image
            })
        }
        return imageToBeReturned
    }
}

extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}

extension UIImage {
    func toString() -> String? {
        let data: Data? = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}
