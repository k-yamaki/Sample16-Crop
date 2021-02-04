//
//  EditListView.swift
//  Sample16-Crop
//
//  Created by keiji yamaki on 2021/02/03.
//

import SwiftUI

struct EditListView: View {
    // 引数
    @Binding var imageList : PhotoImageList     // 写真のリスト
    
    // 内部引数
    @State var selectNo : Int = 0               // 選択した画像の番号
    @State var viewHight : CGFloat = 250        // ビューの高さ
    @State var imageMove : CGSize = .zero   // １個の画像のドラッグ量
    @State var zoom : CGFloat = 1.0         // ビューに表示する時の画像の倍率
    // YAMAKI
    // 切り取りデータ
    @State var cropData = CropData()        //　切り取りデータ
    
    let moveOpacity = 0.7                   // 移動画面の透明度
    let notEdit = -1                        // 選択していない
    
    var body: some View {
        // 画像リストのビュー
        ZStack {
            // 画像リスト分のデータを表示
            ForEach (imageList.photoList.indices, id: \.self) { index in
                let item = imageList.photoList[index]
                let rect = getRect(index: index, photoImage: item)
                let cropRect = getCropRect(index: index, photoImage: item)
                VStack {
                    // 切り取りしていない画像の一覧
                    ImageView(photoImage: item)
                        // 選択すると、赤の枠をつける
                        .border(Color.red, width: selectNo == index ? 2 : 0)
                        // 左上原点に設定
                        .frame(width:rect.width, height:rect.height, alignment: .topLeading)
                        .position(x:rect.minX, y:rect.minY)
                        .opacity(selectNo == index ? moveOpacity : 1)
                        .mask(
                            Rectangle()
                                .frame(width: cropRect.width, height: cropRect.height)
                                .position(x:cropRect.minX, y:cropRect.minY)
                        )
                        // タップで画像を選択
                        .onTapGesture{
                            if selectNo == index {
                                selectNo = notEdit
                            }else {
                                selectNo = index
                                // YAMAKI
                                // 切り抜き情報を設定
                                cropData.set(imageRect:item.rect, cropRect: item.crop)
                            }
                        }
                }

            }
            .onAppear{
                // ビューの高さとフラット写真のサイズから表示する倍率を求める
                let rect = imageList.photoRect  // フラット写真の矩形範囲
                zoom = viewHight / rect.height
                print("zoom = \(zoom)")
            }
            // YAMAKI
            // 切り抜き画面の表示
            if selectNo != notEdit {
                CropView(cropData: $cropData, zoom: $zoom)
                    // 更新フラグが立つと、画像データに更新
                    .onChange(of: cropData.update, perform: { value in
                        // 更新ならば、画像データの切り取りを更新
                        if value == true {
                            imageList.photoList[selectNo].crop = cropData.cropRect
                            cropData.update = false
                            // 切り抜き情報を設定
                            cropData.set(imageRect:imageList.photoList[selectNo].rect, cropRect: imageList.photoList[selectNo].crop)
                        }
                    })
            }
        }.offset()
    }
    // YAMAKI
    // 画像サイズの設定
    func getRect(index: Int, photoImage: PhotoImage)->CGRect {
        var rect : CGRect   // 画像の矩形
        // 選択画像と、それ以外の場合で、画像の矩形を指定
        if selectNo == index {
            // 選択画像の場合は、ドラッグの移動量を加える
            rect = CGRect(x:photoImage.rect.midX * zoom + imageMove.width,
                          y:photoImage.rect.midY * zoom + imageMove.height,
                          width: photoImage.rect.width * zoom,
                          height: photoImage.rect.height * zoom)
        }else{
            rect = CGRect(x:photoImage.rect.midX * zoom,
                          y:photoImage.rect.midY * zoom,
                          width: photoImage.rect.width * zoom,
                          height: photoImage.rect.height * zoom)
        }
        print("moto \(index) = \(rect)")
        return rect
    }
    // 切り取りの矩形を取得
    func getCropRect(index: Int, photoImage: PhotoImage)->CGRect {
        var rect : CGRect   // 切り取りの矩形
        // 選択画像と、それ以外の場合で、切り取りの矩形を指定
        if selectNo == index {
            // 選択画像の場合は、切り取りデータとドラッグの移動量を加える
            rect = CGRect(x:cropData.cropRect.midX * zoom + imageMove.width,
                          y:cropData.cropRect.midY * zoom + imageMove.height,
                          width: cropData.cropRect.width * zoom,
                          height: cropData.cropRect.height * zoom)
        }else{
            // 選択画像以外の場合は、画像データの切り取りデータを使用
            rect = CGRect(x:photoImage.crop.midX * zoom,
                          y:photoImage.crop.midY * zoom,
                          width: photoImage.crop.width * zoom,
                          height: photoImage.crop.height * zoom)
        }
        print("crop \(index) = \(rect)")
        return rect
    }
}
