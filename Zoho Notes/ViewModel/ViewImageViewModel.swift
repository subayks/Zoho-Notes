//
//  ViewImageViewModel.swift
//  Zoho Notes
//
//  Created by Subendran on 05/10/20.
//  Copyright © 2020 Subendran. All rights reserved.
//

import Foundation
class ViewImageViewModel {
    
    var model : [NotesData]?
    var selectedIndex = Int()
    
    init(model:[NotesData],selectedIndex:Int){
        self.model = model
        self.selectedIndex = selectedIndex
    }
    
}
