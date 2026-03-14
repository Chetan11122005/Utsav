import SwiftUI

struct FestivalIconView: View {

    let imageName: String
    let color: Color
    var size: CGFloat = 32

    var body: some View {
        if UIImage(named: imageName) != nil {

            Image(imageName)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: size, height: size)
                .foregroundStyle(color)

        } else {

            Image(systemName: imageName)
                .font(.system(size: size))
                .foregroundStyle(color)
        }
    }
}
