//
//  StringExtensions.swift
//  Offradio
//
//  Created by Dimitris C. on 11/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Foundation

extension String {
    
    func convertHTMLEntities(fallback: String = "") throws -> String {
        guard let data = data(using: .utf8) else { return fallback }
        
        return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                        NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue],
                                  documentAttributes: nil).string
    }
    
}
