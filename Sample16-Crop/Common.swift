//
//  Common.swift
//  Sample16-Crop
//
//  Created by keiji yamaki on 2021/02/03.
//

import SwiftUI

// 撮影の方向
enum DirectionType: Int16 {
    case none = 0       // 方向なし
    case up = 1         // 上
    case down = 2       // 下
    case left = 3       // 左
    case right = 4      // 右
}
