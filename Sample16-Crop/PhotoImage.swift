//
//  PhotoImage.swift
//  Sample16-Crop
//
//  Created by keiji yamaki on 2021/02/03.
//

import SwiftUI
import MapKit
import CoreData

// フラット写真の画像：フラット写真を構成する個々の画像のデータ、画像は画像構造体を指定
// 撮影で作成。

struct PhotoImage {
    var image = UIImage(named: "sample")
    private var storeRect: CGRect       // 画像を表示する矩形
    // YAMAKI
    private var storeCropRect: CGRect   // 画像を切り取る矩形
    
    // アクセス：　画像を表示する矩形と画像
    var rect : CGRect { get { return storeRect }}           // 表示する矩形

    // YAMAKI
    var crop : CGRect { get { return storeCropRect }
        set { storeCropRect = newValue}
    }
    
    // 初期化：画像と位置とサイズを指定（切り取りなし）
    init (rect: CGRect){
        self.storeRect = rect
        self.storeCropRect = rect
    }
    // YAMAKI
    // 更新：表示位置の移動
    mutating func moveRect (move: CGSize){
        self.storeRect = self.storeRect.offsetBy(dx: move.width, dy: move.height)
        self.storeCropRect = self.storeCropRect.offsetBy(dx: move.width, dy: move.height)
    }
}

// 位置に全体のビューの位置を設定する
struct PhotoImageList {
    var photoList : [PhotoImage] = []  // 画像のリスト
    private var storeImage : UIImage?               // フラット画像
    var image : UIImage { get { return storeImage! }}
    
    // アクセスデータ
    var photoRect : CGRect { get { return getPhotoRect() }}

    // 画像の移動：１つのみ
    mutating func moveImage(moveSize: CGSize, no: Int){
        photoList[no].moveRect(move: moveSize)
    }
    // 画像の移動：全ての移動
    private mutating func moveImage(moveSize: CGSize, direction: DirectionType) {
        // 画像リストの全ての画像の位置を移動
        for index in 0 ..< photoList.count {
            photoList[index].moveRect(move: moveSize)
        }
    }
    // フラット画像の位置情報（マップの始点・終点とクリッピングの矩形）
    private func getPhotoRect()->CGRect{
        // 画像がない時は、NILを返す
        guard photoList.count > 0 else {
            return .zero
        }
        // 初期設定
        var minX = photoList[0].rect.minX
        var maxX = photoList[0].rect.maxX
        var minY = photoList[0].rect.minY
        var maxY = photoList[0].rect.maxY

        // 画像のX軸上の最小と最大の位置のマップ位置を取得する
        for image in photoList {
            // X軸の最小値の更新
            if image.rect.minX < minX {
                minX = image.rect.minX
            }
            // X軸の最大値の更新
            if image.rect.maxX > maxX {
                maxX = image.rect.maxX
            }
            // Y軸の最小値の更新
            if image.rect.minY < minY {
                minY = image.rect.minY
            }
            // Y軸の最大値の更新
            if image.rect.maxY > maxY {
                maxY = image.rect.maxY
            }
        }
        return CGRect(x:minX, y:minY, width:maxX - minX, height: maxY - minY)
    }
    // YAMAKI：
    // 画像のリストからフラット画像を作成：画像の切り取りを追加
    mutating func setFlatImage() {
        // 画像がない時は、処理しない
        guard photoList.count > 0 else {
            return
        }

        // 指定された画像の大きさのコンテキストを用意.
        UIGraphicsBeginImageContext(CGSize(width: photoRect.width, height: photoRect.height))
        // 画像のリスト分を回す
        for item in photoList {
            // YAMAKI 切り取りした画像を描画
            // コンテキストに画像を描画する.
            item.image!.draw(in: item.crop)
        }
        // コンテキストからUIImageを作る.
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        // コンテキストを閉じる.
        UIGraphicsEndImageContext()
        // フラット画像を設定
        storeImage = newImage
    }
}
