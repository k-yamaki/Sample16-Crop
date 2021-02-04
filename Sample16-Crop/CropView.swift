//
//  CutLineView.swift
//  Sample16-Crop
//
//  Created by keiji yamaki on 2021/02/03.
//

import SwiftUI

// 切り抜きの画面
struct CropView: View {
    @Binding var cropData: CropData     // 切り抜きデータ
    @Binding var zoom: CGFloat          // 拡大率
    
    var body: some View {
        // 切り抜きのマーカーを上下左右に表示
        CropMarkerView(cropData: $cropData, zoom: $zoom, direction: .up)
        CropMarkerView(cropData: $cropData, zoom: $zoom, direction: .down)
        CropMarkerView(cropData: $cropData, zoom: $zoom, direction: .left)
        CropMarkerView(cropData: $cropData, zoom: $zoom, direction: .right)
    }
}

// 切り抜きのマーカー画面：マーカーの方向に、画像データと拡大率でマーカーのビューを作成
struct CropMarkerView: View {
    // 引数
    @Binding var cropData: CropData     // 切り抜きデータ
    @Binding var zoom: CGFloat          // 拡大率
    var direction: DirectionType        // 切り取りの方向
    // 定数
    let markerSize: CGFloat = 20.0      // マーカーの太さ
    let markerColor: Color = .blue      // マーカーの色
    let markerOpacity: Double = 0.7     // マーカーの透明度
    let minMarkerSize : CGFloat = 50    // 最小のマーカーのサイズ
    let markerDivided: CGFloat = 5      // マーカーサイズを決定するための、画像の線分に対する分割の数
    
    var body: some View {
        let cutLine = getRect()
        ZStack {
            // 角丸四角形で線を引く
            RoundedRectangle(cornerRadius:20)
                .foregroundColor(markerColor)   // マーカーの色
                .opacity(markerOpacity)         // マーカーの透明度
                // マーカーのサイズと位置
                .frame(width:cutLine.width, height: cutLine.height)
                .position(x:cutLine.midX, y:cutLine.midY)
                // ドラッグでマーカーを移動
                .gesture(markerDrag)
        }
    }
    // ドラッグでマーカーを移動
    var markerDrag: some Gesture {
        DragGesture()
            // ドラッグ中：画面で切り取りを実施
            .onChanged { value in
                cropData.direction = direction
                let move = CGSize(width: value.translation.width / zoom, height: value.translation.height / zoom)
                cropData.move(move: move)
            }
            // ドラッグ確定：画像データに反映
            .onEnded { value in
                cropData.direction = direction
                let move = CGSize(width: value.translation.width / zoom, height: value.translation.height / zoom)
                cropData.move(move: move)
                // 画像データに反映
                cropData.update = true
            }
    }
    // 切り取り矩形とマーカーの方向で、マーカーの四角形を返す
    func getRect()->CGRect {
        var rect : CGRect                   // マーカーの四角形
        var markWidth: CGFloat              // 横バージョンのマーカーサイズ
        var markHeight: CGFloat             // 縦バージョンのマーカーサイズ
        // 縦と横のサイズを設定
        let width = cropData.cropRect.width * zoom
        let height = cropData.cropRect.height * zoom
        // 縦・横バージョンのマーカーのサイズを設定
        markWidth = width / markerDivided
        if markWidth < minMarkerSize {
            markWidth = minMarkerSize
        }
        markHeight = height / markerDivided
        if markHeight < minMarkerSize {
            markHeight = minMarkerSize
        }
        
        switch direction {
        case .none:
            print("カット線が選択されていません")
            return .zero
        case .up:   // 上は、横バージョンのマーカーを中央に設置
            let x = cropData.cropRect.minX * zoom + (width - markWidth) / 2
            rect = CGRect(x: x, y: cropData.cropRect.minY * zoom - markerSize / 2, width: markWidth, height: markerSize)
        case .down:
            let x = cropData.cropRect.minX * zoom + (width - markWidth) / 2
            rect = CGRect(x: x, y: cropData.cropRect.maxY * zoom - markerSize / 2, width: markWidth, height: markerSize)
        case .left:
            let y = cropData.cropRect.minY * zoom + (height - markHeight) / 2
            rect = CGRect(x: cropData.cropRect.minX * zoom - markerSize / 2, y: y, width: markerSize, height: markHeight)
        case .right:
            let y = cropData.cropRect.minY * zoom + (height - markHeight) / 2
            rect = CGRect(x: cropData.cropRect.maxX * zoom - markerSize / 2, y: y, width: markerSize, height: markHeight)
        }
        return rect
    }
}

