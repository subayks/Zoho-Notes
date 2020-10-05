//
//  DataManager.swift
//  Zoho Notes
//
//  Created by Subendran on 02/10/20.
//  Copyright © 2020 Subendran. All rights reserved.
//

import UIKit
import CoreData

open class DataManager: NSObject {

    public static let sharedInstance = DataManager()

    private override init() {}

    // Helper func for getting the current context.
    private func getContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.persistentContainer.viewContext
    }

    func retrieveUser() -> NSManagedObject? {
        guard let managedContext = getContext() else { return nil }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ZohoNotes")

        do {
            let result = try managedContext.fetch(fetchRequest) as! [ZohoNotes]
            if result.count > 0 {
                // Assuming there will only ever be one User in the app.
                return result[0]
            } else {
                return nil
            }
        } catch let error as NSError {
            print("Retrieiving user failed. \(error): \(error.userInfo)")
           return nil
        }
    }

    func saveBook(_ book: NotesData) {
        print(NSStringFromClass(type(of: book)))
        guard let managedContext = getContext() else { return }
        guard let user = retrieveUser() else { return }

        var books: [NotesData] = []
        if let pastBooks = user.value(forKey: "notes") as? [NotesData] {
            books += pastBooks
        }
        books.append(book)
        user.setValue(books, forKey: "notes")

        do {
            print("Saving session...")
            try managedContext.save()
        } catch let error as NSError {
            print("Failed to save session data! \(error): \(error.userInfo)")
        }
    }

}
