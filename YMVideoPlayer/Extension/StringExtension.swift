//
//  StringExtension.swift
//  CustomVideoPlayer
//
//  Created by Yasheed Muhammed on 02/02/2020.
//  Copyright © 2020 yasheed. All rights reserved.
//

import Foundation

extension String {
    func percentEncoded() -> String {
           guard let string = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return ""}
           return string
    }
}

