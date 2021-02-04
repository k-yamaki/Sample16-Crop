//
//  ContentView.swift
//  Sample16-Crop
//
//  Created by keiji yamaki on 2021/02/03.
//

import SwiftUI

struct ContentView: View {
    @State var imageList = PhotoImageList()     // 写真のリスト
    
    var body: some View {
        // 切り取り用の画像リスト
        EditListView(imageList: $imageList)
            .onAppear{
            // 写真のリストデータを作成
            for index in 0 ... 2 {
                let photoImage = PhotoImage(rect: CGRect(x: 100 * index + 20, y: 20, width: 100, height: 150))
                imageList.photoList.append(photoImage)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
