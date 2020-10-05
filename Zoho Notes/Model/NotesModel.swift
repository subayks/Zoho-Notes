//
//  NotesModel.swift
//  Zoho Notes
//
//  Created by Subendran on 02/10/20.
//  Copyright © 2020 Subendran. All rights reserved.
//

import Foundation
struct NotesModel : Codable {
    let id : String?
    let title : String?
    let body : String?
    let time : String?
    let image : String?


    enum CodingKeys: String, CodingKey {

        case id = "id"
        case title = "title"
        case body = "body"
        case time = "time"
        case image = "image"

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        body = try values.decodeIfPresent(String.self, forKey: .body)
        time = try values.decodeIfPresent(String.self, forKey: .time)
        image = try values.decodeIfPresent(String.self, forKey: .image)
    }

}
