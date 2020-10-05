//
//  ViewController.swift
//  Zoho Notes
//
//  Created by Subendran on 02/10/20.
//  Copyright © 2020 Subendran. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import NVActivityIndicatorView
import CoreData

public class NotesData : NSObject {
    var title: String = ""
    var notes:String = ""
    var image:String = ""
    var date:String = ""
    var id:String = ""
}
class ViewController: UIViewController,NVActivityIndicatorViewable {
    //Collection view for notes
    @IBOutlet weak var collectionViewNotes: UICollectionView!
    //Button to add new note
    @IBOutlet weak var buttonAdd: UIButton!
   //view model for this class
    var notesViewModel = NotesViewModel()
    
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Notes"
        self.view.backgroundColor = .black
        self.collectionViewNotes.backgroundColor = .black
        buttonAdd.layer.cornerRadius = buttonAdd.layer.frame.height/2
        buttonAdd.backgroundColor = .red
        self.notesViewModel.localStoredData = self.notesViewModel.retrieveSavedUsers() ?? []
        makeApiCall()
    }
    
    //MARK:- Action for new note
    @IBAction func didTapAddNewNotes() {
        guard let vc = storyboard?.instantiateViewController(identifier: "AddNewNotesView") as? AddNewNotesView else {
            return
        }
        vc.title = "New Notes"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { notesData in
            self.navigationController?.popViewController(animated: true)
            self.notesViewModel.appendValues(user: notesData)
            self.collectionViewNotes.isHidden = false
            self.collectionViewNotes.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
     //MARK:- API Call
        func makeApiCall() {
            let size = CGSize(width: 50, height: 50)
            self.startAnimating(size, message: "Loading", messageFont: .none, type: .ballScaleRippleMultiple, color: .white, fadeInAnimation: .none)
            let finalURL = "https://raw.githubusercontent.com/RishabhRaghunath/JustATest/master/posts"
            if Reachability.isConnectedToNetwork() {
                
                notesViewModel.getArticleResponse(withBaseURl: finalURL, withParameters: "", completionHandler: { (status: Bool?, errorMessage: String?, errorCode: String?)  -> Void in
                    DispatchQueue.main.async {
                        if status == true {
                            print("Success")
                            self.stopAnimating()
                            self.collectionViewNotes.reloadData()
                        }
                    }
                })
            } else {
                let alert = UIAlertController(title: "Alert", message: "Please check your internet connection", preferredStyle: UIAlertController.Style.alert)
                          alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
                          self.present(alert, animated: true, completion: nil)
            }
        }
}

//MARK:- Extension for collection view delegates
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.notesViewModel.numberOfItems()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.width/3, height: 99)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "notesCell", for: indexPath) as! NotesCollectionViewCell
        cell.backGroundViewForCell.backgroundColor = self.randomColor()
        cell.backGroundViewForCell?.layer.cornerRadius = 10
        cell.backGroundViewForCell?.clipsToBounds = true
        cell.notesTitle.text = self.notesViewModel.model[indexPath.row].title
        cell.notesDetail.text = ""
        cell.date.text = self.notesViewModel.model[indexPath.row].date
        cell.frame.size.width = self.view.frame.width / 3
               cell.frame.size.height = self.view.frame.height / 3
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(identifier: "ViewNotes") as? ViewNotesViewController else {
            return
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        
        vc.title = "View Notes"
        vc.viewModel = self.notesViewModel.createViewNotesViewModel(index:indexPath.row)
        navigationController?.pushViewController(vc, animated: true)
    }
   

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }

    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    //Set random colors for cell
    func randomColor() -> UIColor {
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha:1.0)
        
    }
    
}
