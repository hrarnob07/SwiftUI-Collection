//
//  Copyright  All rights reserved.
//

import Foundation
import SwiftUI

private struct ModernCoolToast: ViewModifier {
    @Binding var data: CoolToastData?
    let padding: CGFloat

    @State private var isPresented: Bool
    @State var dismissDispatchWorkItem: DispatchWorkItem? = nil
    @State var lastData: CoolToastData = .init()

    init(data: Binding<CoolToastData?>, padding: CGFloat) {
        self._data = data
        self.padding = padding

        if let data = data.wrappedValue {
            self.lastData = data
        }

        if data.wrappedValue == .none {
            self.isPresented = false
        } else {
            self.isPresented = true
        }
    }

    func body(content: Content) -> some View {
        ZStack {
            content

            VStack {
                Spacer()

                if isPresented {
                    HStack {
                        CoolToastContainer(
                            isPresented: $isPresented,

                            icon: data?.icon ?? lastData.icon,
                            iconColor: data?.iconColor ?? lastData.iconColor,
                            title: data?.title ?? lastData.title,
                            message: data?.message ?? lastData.message,
                            type: data?.type ?? lastData.type,
                            anchor: data?.anchor ?? lastData.anchor,
                            animation: data?.animation ?? lastData.animation,
                            padding: padding,
                            dismiss: dismiss
                        )
                        .onTapGesture {
                            dismiss()
                        }
                    }
                }
            }
        }
        .onChange(of: data) { newValue in
            if newValue == CoolToastData.emptyInstance() {
                isPresented = false

                dismissDispatchWorkItem?.cancel()
            } else {
                isPresented = true

                startDismissCountdown()
            }
        }
    }

    private func dismiss() {
        dismissDispatchWorkItem?.cancel()

        isPresented = false

        data = .emptyInstance()
    }

    private func startDismissCountdown() {
        dismissDispatchWorkItem?.cancel()

        dismissDispatchWorkItem = DispatchWorkItem {
            dismiss()
        }

        if let workItem = dismissDispatchWorkItem {
            DispatchQueue.main.asyncAfter(
                deadline: .now() + (data?.duration ?? 0),
                execute: workItem
            )
        }
    }
}

private struct CoolToast: ViewModifier {
    @Binding var isPresented: Bool
    let data: CoolToastData
    let padding: CGFloat

    @State var dismissDispatchWorkItem: DispatchWorkItem? = nil

    func body(content: Content) -> some View {
        ZStack {
            content

            VStack {
                Spacer()

                if isPresented {
                    CoolToastContainer(
                        isPresented: $isPresented,
                        icon: data.icon,
                        iconColor: data.iconColor,
                        title: data.title,
                        message: data.message,
                        type: data.type,
                        anchor: data.anchor,
                        animation: data.animation,
                        padding: padding,
                        dismiss: dismiss
                    )
                    .onTapGesture {
                        dismiss()
                    }
                }
            }
        }
        .onChange(of: isPresented) { newValue in
            if newValue {
                startDismissCountdown()
            } else {
                dismissDispatchWorkItem?.cancel()
            }
        }
    }

    private func dismiss() {
        dismissDispatchWorkItem?.cancel()

        isPresented = false
    }

    private func startDismissCountdown() {
        dismissDispatchWorkItem?.cancel()

        dismissDispatchWorkItem = DispatchWorkItem {
            dismiss()
        }

        if let workItem = dismissDispatchWorkItem {
            DispatchQueue.main.asyncAfter(
                deadline: .now() + (data.duration),
                execute: workItem
            )
        }
    }
}

public enum ToastType {
    case regular
    case success
    case warning
    case error
    case info
    case simple
}

struct CoolToastContainer: View {
    @Binding var isPresented: Bool
    let icon: String?
    let iconColor: Color
    let title: String?
    let message: String
    let type: ToastType
    let anchor: CoolToastAnchor
    let animation: Animation
    let padding: CGFloat
    let dismiss: () -> Void

    var body: some View {
        VStack {
            if case .bottom = anchor {
                Spacer()
            }
            if case .leading = anchor {
                Spacer()
            }

            HStack {
                if case .trailing = anchor {
                    Spacer()
                }

                if isPresented {
                    CoolToastView(
                        icon: icon,
                        title: title,
                        message: message,
                        type: type,
                        iconColor: iconColor,
                        paddingBottom: padding
                    )
                    .padding(anchor.getEdge(), padding)
                    .onTapGesture {
                        dismiss()
                    }
                } else {
                    EmptyView()
                }
                if case .leading = anchor {
                    Spacer()
                }
            }

            if case .top = anchor {
                Spacer()
            }
            if case .trailing = anchor {
                Spacer()
            }
        }
        .animation(animation, value: isPresented)
        .transition(.opacity)
    }
}

struct coolToastSubView: View{
    let icon: String
    let message: String
    let iconColor: Color
    var body: some View{
        HStack(spacing: 0) {
            Spacer().frame(width: 12)

            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(iconColor)
            Spacer().frame(width: 8)

            Text(message)
                .font(.system(size: 14, weight: .medium))

            Spacer().frame(width: 16)
        }
        .frame(height: 46)
        .background(Color.systemWhite)
        .cornerRadius(23)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct coolToastOldView: View{
    let icon: String
    let title: String
    let message: String
    let type: ToastType
    let fontColor: Color
    let bgColor: Color
    
    
    var body: some View{
        
        HStack(spacing: 0) {
            Spacer().frame(width: 6)
            VStack(alignment: .leading, spacing: 0) {
                Image(systemName: icon)
                    .font(.system(size: 30))
                    .foregroundColor(fontColor)
                Spacer()
            }.padding([.top, .leading], 8)

            Spacer().frame(width: 8)
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(fontColor)
                Text(message)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(fontColor)
                    .lineLimit(1)
                    .padding(.top, 2)
                Spacer()
            }.padding([.top, .leading], 8)

            Spacer().frame(width: 40)

            VStack(alignment: .leading, spacing: 0) {
                Button {} label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14))
                        .foregroundColor(fontColor)
                }

                Spacer()
            }.padding([.top, .leading], 8)

            Spacer().frame(width: 10)
        }
        .frame(height: 55)
        .background(bgColor)
        .cornerRadius(6)
        .shadow(color: bgColor.opacity(0.1), radius: 0, x: 0, y: 0)
    }
}

private struct CoolToastView: View {
    let icon: String?
    let title: String?
    let message: String
    let type: ToastType
    let iconColor: Color
    let paddingBottom: CGFloat

    var body: some View {
        
        if type == .simple{
            coolToastSubView(
                icon: getIconName(type: type, iconExist: icon ?? "") , message: message, iconColor: iconColor
            )
        }
       
        else {
            coolToastOldView(icon: self.getIconName(type: type, iconExist: icon ?? ""),
                             title: self.getTitle(type: type, title: title ?? ""),
                             message: message,
                             type: type,
                             fontColor: self.getToastFontColor(type: type),
                             bgColor: self.getToastBGColor(type: type)
                    )
        }
    }

    func getToastBGColor(type: ToastType) -> Color {
        switch type {
        case .regular, .simple:
            return Color(.white)
        case .error:
            return Color(.systemRed)
        case .success:
            return Color(.systemGreen)

        case .warning:
            return Color(.systemOrange)

        case .info:
            return Color(.systemCyan)
        }
    }

    func getToastFontColor(type: ToastType) -> Color {
        switch type {
        case .regular,.simple:
            return Color(.black)
        case .error, .info, .warning, .success:
            return .white
        }
    }
    
    func getToastIconColor(type: ToastType) -> Color {
        switch type {
        case .regular, .simple:
            return Color(.black)
        case .error, .info, .warning, .success:
            return .white
        }
    }

    func getIconName(type: ToastType, iconExist: String = "") -> String {
        if !iconExist.isEmpty {
            return iconExist
        }

        switch type {
        case .regular, .success,.simple:
            return "checkmark.circle.fill"
        case .error:
            return "xmark.circle.fill"
        case .warning:
            return "exclamationmark.triangle.fill"

        case .info:
            return "i.circle.fill"
        }
    }

    func getTitle(type: ToastType, title: String) -> String {
        if !title.isEmpty {
            return title
        }

        switch type {
        case .regular, .simple:
            return "Success!"
        case .error:
            return "Error!"
        case .success:
            return "Success!"

        case .warning:
            return "Warning!"

        case .info:
            return "Info!"
        }
    }
}

// MARK: - Extensions

extension View {
    func coolToast(
        isPresented: Binding<Bool>,
        icon: String = "",
        iconColor: Color = Color(.systemGreen),
        title: String = "",
        message: String,
        anchor: CoolToastAnchor,
        duration: TimeInterval = 3.0,
        animation: Animation = .linear(duration: 0.3),
        padding: CGFloat = 16
    ) -> some View {
        modifier(
            CoolToast(isPresented: isPresented,
                      data: CoolToastData(
                          icon: icon,
                          title: title,
                          message: message,
                          anchor: anchor,
                          duration: duration,
                          animation: animation

                      ),
                      padding: padding)
        )
    }

    func coolToast(
        data: Binding<CoolToastData?>,
        padding: CGFloat = 16
    ) -> some View {
        modifier(
            ModernCoolToast(
                data: data,
                padding: padding
            )
        )
    }

    func coolToast(
        isPresented: Binding<Bool>,
        data: CoolToastData,
        padding: CGFloat = 16
    ) -> some View {
        modifier(
            CoolToast(
                isPresented: isPresented,

                data: CoolToastData(
                    icon: data.icon,
                    message: data.message,
                    anchor: data.anchor,
                    duration: data.duration,
                    animation: data.animation
                ),
                padding: padding
            )
        )
    }
}

// MARK: - Models

enum CoolToastAnchor {
    case top
    case bottom
    case trailing
    case leading

    func getEdge() -> Edge.Set {
        switch self {
        case .top:
            return Edge.Set.top
        case .bottom:
            return Edge.Set.bottom
        case .trailing:
            return Edge.Set.trailing
        case .leading:
            return Edge.Set.leading
        }
    }
}

struct CoolToastData: Equatable {
    let icon: String
    let iconColor: Color
    let title: String
    let message: String
    let type: ToastType
    let anchor: CoolToastAnchor
    let duration: TimeInterval
    let animation: Animation

    init(
        icon: String = "",
        iconColor: Color = Color(.systemGreen),
        title: String = "",
        message: String = "",
        type: ToastType = .success,
        anchor: CoolToastAnchor = .top,
        duration: TimeInterval = 3.0,
        animation: Animation = .linear(duration: 0.3)
    ) {
        self.icon = icon
        self.title = title
        self.iconColor = iconColor
        self.message = message
        self.type = type
        self.anchor = anchor
        self.duration = duration
        self.animation = animation
    }

    static func emptyInstance() -> CoolToastData {
        return CoolToastData(
            icon: "",
            title: "",
            message: "",
            type: .success,
            anchor: .top,
            duration: 0.0,
            animation: .default
        )
    }
}

// MARK: - Previews

struct CoolToast_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack {
            CoolToastView(
                icon: "checkmark.circle.fill",
                
                title: nil,
                message: "Answer Saved ",
                type: .success,
                iconColor: Color(.green),
                
                paddingBottom: 16
            )
            
            CoolToastView(
                icon: "",
                
                title: nil,
                message: "Answer Saved ",
                type: .warning,
                iconColor: Color(.green),
                paddingBottom: 16
            )
            CoolToastView(
                icon: "",
                
                title: nil,
                message: "Answer Saved ",
                type: .error,
                iconColor: Color(.green),
                paddingBottom: 16
            )
            
            CoolToastView(
                icon: "",
                title: nil,
                message: "Answer Saved ",
                type: .info,
                iconColor: Color(.green),
                paddingBottom: 16
            )
            
            CoolToastView(
                icon: "",
                title: nil,
                message: "Answer Saved ",
                type: .simple,
                iconColor: Color(.green),
                paddingBottom: 16
            )
            
           

        }
    }
}
