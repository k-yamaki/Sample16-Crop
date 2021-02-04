//
//  ImageView.swift
//  Sample16-Crop
//
//  Created by keiji yamaki on 2021/02/03.
//
// フラット写真の１画像を表示する画面
import SwiftUI

struct ImageView: View {
    var photoImage : PhotoImage     // １画像のデータ
    var no : Int?                   // 番号の表示（Nilの場合は表示しない）
    
    var body: some View {
        ZStack (alignment: .topLeading){
            Image("sample")
                .resizable()    // ビューのサイズに調整する
                .scaledToFit()
        }
    }
}
