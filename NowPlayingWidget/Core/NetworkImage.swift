//
//  NetworkImage.swift
//  NowPlayingWidgetExtension
//
//  Created by Dimitrios Chatzieleftheriou on 25/09/2020.
//  Copyright © 2020 decimal. All rights reserved.
//

import SwiftUI

struct NetworkImage: View {
    
    let urlString: String
    
    let placeholderName: String
    
    var body: some View {
        Group {
            if let url = URL(string: urlString),
               let imageData = try? Data(contentsOf: url),
               let uiImage = UIImage(data: imageData)
            {
                Image(uiImage: uiImage)
                    .resizable()
            }
            else {
                Image(placeholderName)
                    .resizable()
            }
        }
    }
    
}
