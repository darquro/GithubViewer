import SwiftUI
import NukeUI

public struct SmallCardView: View {

    @Binding var item: CardViewEntity

    public init(item: Binding<CardViewEntity>) {
        self._item = item
    }

    public var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(item.title)
                    .foregroundColor(Assets.Colors.titleText.color)
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                LazyImage(source: item.imageURL, resizingMode: .aspectFill)
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    .shadow(color: .gray, radius: 1, x: 0, y: 0)
            }
            Text(item.description ?? "")
                .foregroundColor(Assets.Colors.bodyText.color)
                .lineLimit(nil)
            HStack {
                Text(item.language ?? "")
                    .foregroundColor(Assets.Colors.secondaryText.color)
                    .font(.footnote)
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
        .padding(16)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray, lineWidth: 1)
        )
        .padding(8)
    }
}

struct SmallCardView_Previews: PreviewProvider {

    @State static var item: CardViewEntity = .init(imageURL: .init(string: "https://avatars.githubusercontent.com/u/10639145?s=200&v=4")!,
                                                   title: "swift",
                                                   subTitle: "apple",
                                                   language: "Swift",
                                                   star: 1000,
                                                   description: "The Swift Programming Language",
                                                   url: .init(string: "https://github.com/apple/swift")!)

    static var previews: some View {
        Group {
            SmallCardView(item: $item)
                .preferredColorScheme(.light)
            SmallCardView(item: $item)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.fixed(width: 400, height: 240))
    }
}
