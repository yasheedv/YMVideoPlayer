//
//  YMPlayerDataSource.swift
//  CustomVideoPlayer
//
//  Created by Yasheed Muhammed on 02/02/2020.
//  Copyright © 2020 yasheed. All rights reserved.
//

import Foundation
import AVKit

public protocol YMPlayerDataSource: class {
    func videoPathsForYMPlayer() -> [String]
}
