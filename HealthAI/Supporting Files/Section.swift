//
//  Section.swift
//  HealthAI
//
//  Created by Feng Guo on 11/24/18.
//  Copyright © 2018 Team9. All rights reserved.
//

import Foundation


struct Section {
    var genre: String!
    var movies: [String]!
    var expanded: Bool!
    
    init(genre: String, movies: [String], expanded: Bool) {
        self.genre = genre
        self.movies = movies
        self.expanded = expanded
    }
}
