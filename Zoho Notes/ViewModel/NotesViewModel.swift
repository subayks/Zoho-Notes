//
//  NotesViewModel.swift
//  Zoho Notes
//
//  Created by Subendran on 02/10/20.
//  Copyright © 2020 Subendran. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class NotesViewModel {
    
    var notesModel : [NotesModel]?
    var model :[NotesData] = []
    var localStoredData  :[NotesData] = []
    
    
    //MARK:- Api Call
    func getArticleResponse(withBaseURl finalURL: String, withParameters parameters: String, completionHandler: @escaping (Bool, String?, String?) -> Void) {
        
        let finalURL = "https://raw.githubusercontent.com/RishabhRaghunath/JustATest/master/posts"
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters: "", withHttpMethod: "GET", withContentType: "application/hal+json", completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completionHandler(false, error , errorCode)
                
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    
                    let decoder = JSONDecoder()
                    let values = try! decoder.decode([NotesModel].self, from: result!)
                    self.notesModel = values
                    if let model = self.notesModel {
                        
                        for i in 0..<model.count {
                            let note = model[i]
                            let modelData = NotesData()
                            
                            modelData.notes = note.body ?? ""
                            modelData.title = note.title ?? ""
                            modelData.date = note.time ?? ""
                            modelData.image = note.image ?? ""
                            modelData.id = note.id ?? ""
                            if self.checkForDublication(user: modelData) {
                                self.appendValues(user: modelData)
                            } else {
                                if let retrivedVaue = self.setValueForModel() {
                                    self.model = retrivedVaue
                                }
                            }
                        }
                    }
                    completionHandler(true, error, errorCode)
                    
                } catch let error as NSError {
                    //do something with error
                    completionHandler(false, error.localizedDescription, errorCode)
                    
                }
            }
        }
        )}
    //MARK:- number of items for collection view
    func numberOfItems() ->Int {
        return   self.model.count
    }
    
    //MARK:- method to check dublication
    func checkForDublication(user: NotesData) -> Bool{
        var id = [String]()
        for i in 0..<self.localStoredData.count {
            id.append(self.localStoredData[i].id)
        }
        if id.contains(user.id) {
            return false
        } else {
            return true
        }
        
    }
    
    //MARK:- Append values in core data
    func appendValues(user: NotesData) {
        guard let context = self.getContext() else { return }
        
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "ZohoNotes", into: context)
        self.saveUserData(user: user, newUser: newUser)
        do {
            try context.save()
            print("Success")
        } catch {
            print("Error saving: \(error)")
        }
        if let retrivedVaue = self.setValueForModel() {
            self.model = retrivedVaue
        }
    }
    
    //MARK:- Retrive data from core data
    func setValueForModel() -> [NotesData]? {
        return self.retrieveSavedUsers()
    }
    
   //Method to store in core data
    func saveUserData(user: NotesData,newUser:NSManagedObject) {
        newUser.setValue(user.title, forKey: "title")
        newUser.setValue(user.notes, forKey: "notes")
        newUser.setValue(user.date, forKey: "date")
        newUser.setValue(user.image, forKey: "image")
        newUser.setValue(user.id, forKey: "id")
    }
    
    //Method to retrive data from Core data
    func retrieveSavedUsers() -> [NotesData]? {
        guard let context = self.getContext() else { return nil}
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ZohoNotes")
        request.returnsObjectsAsFaults = false
        var retrievedUsers: [NotesData] = []
        do {
            let results = try context.fetch(request)
            if !results.isEmpty {
                for i in 0..<results.count  {
                    let resultValue = results as! [NSManagedObject]
                    let result = resultValue[i]
                    guard let title = result.value(forKey: "title") as? String else { return nil }
                    guard let notes = result.value(forKey: "notes") as? String else { return nil }
                    guard let date = result.value(forKey: "date") as? String else { return nil }
                    let image = result.value(forKey: "image") as? String
                    let id = result.value(forKey: "id") as? String
                    let modelData = NotesData()
                    
                    modelData.notes = notes
                    modelData.title = title
                    modelData.date = date
                    modelData.image = image ?? ""
                    modelData.id = id ?? ""
                    retrievedUsers.append(modelData)
                }
            }
        } catch {
            print("Error retrieving: \(error)")
        }
        return retrievedUsers
    }
    
    //Method to find selected notes
    func selectedNotes(index:Int) -> NotesData {
        return self.model[index]
    }
    
    //Method to create viewNotesviewModel
    func createViewNotesViewModel(index:Int) -> ViewNotesViewModel {
        return  ViewNotesViewModel.init(model: self.model, selectedIndex: index)
    }
    
    // Helper func for getting the current context.
    private func getContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.persistentContainer.viewContext
    }
}
