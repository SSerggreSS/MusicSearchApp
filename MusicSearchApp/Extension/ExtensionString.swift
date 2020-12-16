//
//  ExtensionString.swift
//  MusicSearchApp
//
//  Created by Сергей  Бей on 14.12.2020.
//

import Foundation

extension String {

    func dateString() -> String? {
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = dateFormatter.date(from: self) else { return nil }
        let stringFromDate = dateFormatter.string(from: date)
        
        guard let index = stringFromDate.range(of: "T")?.lowerBound else { return nil }
        let substringDate = stringFromDate[..<index]
        let dateString = String(substringDate)
        
        return dateString

    }
    
}
