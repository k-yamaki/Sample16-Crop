//
//  CropData.swift
//  Sample16-Crop
//
//  Created by keiji yamaki on 2021/02/03.
//

import SwiftUI

struct CropData {
    private var storeImageRect: CGRect = .zero          // 画像の矩形
    private var beforeCropRect: CGRect = .zero          // 切り取りの矩形（変更前）
    private var afterCropRect: CGRect = .zero           // 切り取りの矩形（変更後）
    private var storeDirection : DirectionType = .none  // 切り取りの方向
    private var storeCropSize: CGFloat = .zero          // 切り取りのサイズ
    private var storeUpdate: Bool = false               // 更新フラグ
    
    // 更新
    var update : Bool {
        get { return storeUpdate }
        set { storeUpdate = newValue }
    }
    // カット線の方向：指定も可能
    var direction : DirectionType {
        get { return storeDirection }
        set { storeDirection = newValue }
    }
    // 現在の切り取りの矩形
    var cropRect : CGRect {
        get { return afterCropRect }
        set { afterCropRect = newValue }
    }
    
    // 初期化：　切り取り０で初期化
    mutating func set(imageRect: CGRect){
        self.storeImageRect = imageRect
        self.beforeCropRect = imageRect
        self.afterCropRect = imageRect
    }
    // 初期化：　画像と切り取りの両方を指定
    mutating func set(imageRect: CGRect, cropRect: CGRect){
        self.storeImageRect = imageRect
        self.beforeCropRect = cropRect
        self.afterCropRect = cropRect
    }
    // カット線を移動：選択した画像のカット専用より
    mutating func move (move: CGSize){
        switch direction {
        case .none:
            print("カット線を移動出来ません。方向を指定してください")
            return
        case .up:
            let up = beforeCropRect.minY + move.height
            // カット線が画像の範囲内ならば、移動する
            if up > storeImageRect.minY && up < storeImageRect.maxY {
                afterCropRect = CGRect(x: beforeCropRect.minX,
                                       y: beforeCropRect.minY + move.height,
                                       width: beforeCropRect.width,
                                       height: beforeCropRect.height - move.height)
            }
        case .down:
            let down = beforeCropRect.maxY + move.height
            // カット線が画像の範囲内ならば、移動する
            if down > storeImageRect.minY && down < storeImageRect.maxY {
                afterCropRect = CGRect(x: beforeCropRect.minX,
                                       y: beforeCropRect.minY,
                                       width: beforeCropRect.width,
                                       height: beforeCropRect.height + move.height)
            }
        case .left:
            let left = beforeCropRect.minX + move.width
            // カット線が画像の範囲内ならば、移動する
            if left > storeImageRect.minX && left < storeImageRect.maxX {
                afterCropRect = CGRect(x: beforeCropRect.minX + move.width,
                                       y: beforeCropRect.minY,
                                       width: beforeCropRect.width - move.width,
                                       height: beforeCropRect.height)
                print("left = \(afterCropRect)")
            }
        case .right:
            let left = beforeCropRect.maxX + move.width
            // カット線が画像の範囲内ならば、移動する
            if left > storeImageRect.minX && left < storeImageRect.maxX {
                afterCropRect = CGRect(x: beforeCropRect.minX,
                                       y: beforeCropRect.minY,
                                       width: beforeCropRect.width + move.width,
                                       height: beforeCropRect.height)
            }
        }
    }

}
