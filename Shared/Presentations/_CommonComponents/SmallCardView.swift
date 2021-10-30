//
//  SmallCardView.swift
//  GitHubViewer
//
//  Created by Kuroda, Yuki | Yuki | ECID on 2021/10/24.
//

import SwiftUI

struct SmallCardView: View {

    struct CardData: Identifiable {
        let id: UUID = .init()
        let image: UIImage
        let title: String
        let language: String?
        let star: Int
        let description: String?
        let url: URL
    }

    let cardData: CardData

    init(_ cardData: CardData) {
        self.cardData = cardData
    }

    var body: some View {
        VStack(alignment: .leading) {
            Image(uiImage: cardData.image)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                .shadow(color: .gray, radius: 1, x: 0, y: 0)

            Text(cardData.title)
                .foregroundColor(.black)
                .font(.title)
                .fontWeight(.bold)

            HStack {
                Text(cardData.language ?? "")
                    .foregroundColor(.gray)
                    .font(.footnote)
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .renderingMode(.template)
                        .foregroundColor(.yellow)
                    Text(String(cardData.star))
                        .foregroundColor(.gray)
                        .font(.footnote)
                }
            }

            Text(cardData.description ?? "")
                .foregroundColor(.black)
                .lineLimit(nil)
        }
        .padding(24)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray, lineWidth: 1)
        )
        .frame(minWidth: 240, maxWidth: 240, minHeight: 180)
        .padding(8)
    }
}

struct SmallCardView_Previews: PreviewProvider {
    static var previews: some View {
        SmallCardView(.init(image: .init(named: "GitHub")!,
                       title: "Title",
                       language: "Swift",
                       star: 1000,
                       description: "Description Text,Description Text,Description Text,Description Text,",
                       url: .init(string: "https://example.com")!))
            .previewLayout(.sizeThatFits)
    }
}
