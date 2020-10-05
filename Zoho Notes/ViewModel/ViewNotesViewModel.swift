//
//  ViewNotesViewModel.swift
//  Zoho Notes
//
//  Created by Subendran on 05/10/20.
//  Copyright © 2020 Subendran. All rights reserved.
//

import Foundation
class ViewNotesViewModel {
    var selectedIndex = Int()
    var imageSelected =  String()
    var model : [NotesData]?
    var url = String()
    var urlButtonName = String()
    var indexOfImage = Int()
    var imageNotes = [NotesData]()
    
    init(model:[NotesData],selectedIndex:Int) {
        self.model = model
        self.selectedIndex = selectedIndex
    }
    //MARK:- Replace Url with hyper link
    func replaceUrl(notesData:NotesData) ->String {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: notesData.notes, options: [], range: NSRange(location: 0, length: notesData.notes.utf16.count))
        
        for match in matches {
            guard let range = Range(match.range, in: notesData.notes) else { continue }
            let url = notesData.notes[range]
            self.url = String(url)
            print(url)
        }
        let replacementText = notesData.notes.replacingOccurrences(of: self.url, with: "")
        if self.url != "" {
            if let r1 = replacementText.range(of: "[")?.upperBound,
                let r2 = replacementText.range(of: "]")?.lowerBound {
                print (String(replacementText[r1..<r2]))
                self.urlButtonName = String(replacementText[r1..<r2])
            }
        }
        return replacementText
    }
    
    func getImageArrayWithIndex() {
        if let  modelValue = self.model {
            for values in modelValue {
                if values.image != "" {
                    imageNotes.append(values)
                }
            }
        }
        for i in 0..<imageNotes.count {
            if imageNotes[i].image == self.imageSelected {
                self.indexOfImage = i
            }
        }
    }
    
    func createViewImageviewModel() -> ViewImageViewModel {
        return ViewImageViewModel.init(model:self.imageNotes , selectedIndex: indexOfImage)
    }
    
}
