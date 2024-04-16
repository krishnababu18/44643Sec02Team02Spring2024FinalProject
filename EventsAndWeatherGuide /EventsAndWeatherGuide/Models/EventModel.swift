//
//  EventModel.swift
//  EventsAndWeatherGuide
//
//  Created by Gattineni manideep on 01/04/2024.
//

import Foundation

struct EventModel: Codable {
    
    var id: String?
    var admin_id: String?
    var name: String?
    var type: String?
    var price: String?
    var location: String?
    var image: String?
    var description: String?
    var start: String?
    var end: String?
    
    init() {}
}
