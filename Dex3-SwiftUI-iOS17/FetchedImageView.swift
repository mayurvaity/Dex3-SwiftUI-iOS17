//
//  FetchedImageView.swift
//  Dex3-SwiftUI-iOS17
//
//  Created by Mayur Vaity on 14/07/24.
//

import SwiftUI

struct FetchedImageView: View {
    let url: URL?
    
    var body: some View {
        //new syntax of if let
        //checking url's optionality
        //imageData - getting data of the image in this obj from url
        //uiImage - converting "imageData" to uiimage
        if let url, let imageData = try? Data(contentsOf: url), let uiImage = UIImage(data: imageData) {
            //creating image vw using this uiimage
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .shadow(color: .black, radius: 6)
        } else {
            //if couldnot get image from url, we will use this vw
            Image(.bulbasaur)
        }
    }
}

#Preview {
    FetchedImageView(url: SamplePokemon.samplePokemon.sprite)
}
