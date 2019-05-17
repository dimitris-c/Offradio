//
//  NSMutableAttributedString+Utils.swift
//  Carlito
//
//  Created by Dimitris C. on 13/08/2016.
//  Copyright © 2016 decimal. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {

    final func set(font aFont: UIFont, range: NSRange? = nil) {
        addAttribute(forName: NSAttributedString.Key.font, value: aFont, range: range)
    }

    final func set(color aColor: UIColor, range: NSRange? = nil) {
        addAttribute(forName: NSAttributedString.Key.foregroundColor, value: aColor, range: range)
    }

    final func set(backgroundColor aColor: UIColor, range: NSRange? = nil) {
        addAttribute(forName: NSAttributedString.Key.backgroundColor, value: aColor, range: range)
    }

    final func set(paragraph aParagraph: NSMutableParagraphStyle, range: NSRange? = nil) {
        addAttribute(forName: NSAttributedString.Key.paragraphStyle, value: aParagraph, range: range)
    }

    final func set(kerning kernValue: CGFloat, range: NSRange? = nil) {
        addAttribute(forName: NSAttributedString.Key.kern, value: kernValue as Any, range: range)
    }

    final func set(link: String, range: NSRange? = nil) {
        addAttribute(forName: NSAttributedString.Key.link, value: link as Any, range: range)
    }

    final func set(strikethrough should: Bool, range: NSRange? = nil) {
        addAttribute(forName: NSAttributedString.Key.strikethroughStyle, value: should ? 1 : 0, range: range)
    }

    final func set(underline style: NSUnderlineStyle, range: NSRange? = nil) {
        addAttribute(forName: NSAttributedString.Key.underlineStyle, value: style, range: range)
    }

    final func addAttribute(forName name: NSAttributedString.Key, value aValue: Any, range: NSRange? = nil) {
        if let range = range, range.location != NSNotFound {
            addAttribute(name, value: aValue, range: range)
        } else {
            addAttribute(name, value: aValue, range: NSRange(location: 0, length: length))
        }
    }
}
