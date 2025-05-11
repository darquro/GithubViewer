import SwiftUI
import NukeUI

public struct BigCardView: View {

    @Binding var item: CardViewEntity

    public init(item: Binding<CardViewEntity>) {
        self._item = item
    }

    public var body: some View {
        VStack(alignment: .leading) {
            HStack {
                LazyImage(source: item.imageURL, resizingMode: .aspectFill)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    .shadow(color: .gray, radius: 1, x: 0, y: 0)

                VStack(alignment: .leading) {
                    Text(item.title)
                        .foregroundColor(Assets.Colors.titleText.color)
                        .font(.title)
                        .fontWeight(.bold)

                    Text(item.subTitle)
                        .foregroundColor(Assets.Colors.secondaryText.color)
                        .font(.title2)
                }
            }

            Text(item.description ?? "")
                .foregroundColor(Assets.Colors.bodyText.color)
                .lineLimit(nil)

            HStack {
                Text(item.language ?? "")
                    .foregroundColor(Assets.Colors.secondaryText.color)
                    .font(.footnote)
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .renderingMode(.template)
                        .foregroundColor(.yellow)
                    Text(String(item.star))
                        .foregroundColor(Assets.Colors.secondaryText.color)
                        .font(.footnote)
                }
            }
        }
        .padding(24)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray, lineWidth: 1)
        )
        .frame(minWidth: 240, minHeight: 180)
        .padding(8)
    }
}

struct BigCardView_Previews: PreviewProvider {

    @State static var item: CardViewEntity = .init(imageURL: .init(string: "https://avatars.githubusercontent.com/u/10639145?s=200&v=4")!,
                                                   title: "swift",
                                                   subTitle: "apple",
                                                   language: "Swift",
                                                   star: 1000,
                                                   description: "The Swift Programming Language",
                                                   url: .init(string: "https://github.com/apple/swift")!)

    static var previews: some View {
        Group {
            BigCardView(item: $item)
                .preferredColorScheme(.light)
            BigCardView(item: $item)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.fixed(width: 400, height: 240))
    }
}
