//
//  CurrentLocationButton.swift
//  CurrentLocationButton
//
//  Created by hoseung Lee on 2021/07/16.
//

import SwiftUI

private var buttonHeight: CGFloat = 35

struct CurrentLocationButton: View {
  var body: some View {
    Button {
    } label: {
      Text("현재위치로 찾기")
    }
    .buttonStyle(CurrentLocationButtonStyle())
  }
}

private struct CurrentLocationButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
      HStack {
        Spacer()
        Image(systemName: "location.circle")
        configuration.label
        Spacer()
      }
      .foregroundColor(.white)
      .frame(height: buttonHeight)
      .font(.system(size: 15, weight: .heavy, design: .rounded))
      .padding([.leading, .trailing])
      .buttonPress(configuration.isPressed)
      .animation(.easeOut(duration: 0.1))
  }
}

private extension View {
  func buttonPress(_ isPressed: Bool) -> some View {
    self.background(
      !isPressed ? AnyView(normal()) : AnyView(pressed())
    )
  }

  func normal() -> some View {
    RoundedRectangle(cornerRadius: 5)
      .foregroundColor(Color.orange)
    }


  func pressed() -> some View {
    RoundedRectangle(cornerRadius: 5)
      .foregroundColor(Color("OrangeButtonPressedColor"))
  }
}

struct CurrentLocationButton_Previews: PreviewProvider {
  static var previews: some View {
    CurrentLocationButton()
      .previewLayout(.sizeThatFits)
  }
}
