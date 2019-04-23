//
//  StringExtensions.swift
//  Offradio
//
//  Created by Dimitris C. on 11/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit

extension String {

    func convertHTMLEntities(fallback: String = "") throws -> String {
        guard let data = data(using: .utf8) else { return fallback }

        return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:
            NSAttributedString.DocumentType.html,
                                                        NSAttributedString.DocumentReadingOptionKey.characterEncoding
                                                            : String.Encoding.utf8.rawValue],
                                  documentAttributes: nil).string
    }

    func fromBase64() -> String {
        guard let data = Data.init(base64Encoded: self) else {
            return ""
        }
        if let result = String(data: data, encoding: .utf8) {
            return result
        }
        return ""
    }

    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }

}
