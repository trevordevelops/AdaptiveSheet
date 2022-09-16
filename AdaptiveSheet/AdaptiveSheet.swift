//
//  AdaptiveSheet.swift
//  AdaptiveSheet
//
//  Created by Trevor Welsh on 9/16/22.
//

import SwiftUI

struct AdaptiveSheet<T: View>: ViewModifier {
    @Binding var isPresented: Bool
    let sheetContent: T
    let detents : [UISheetPresentationController.Detent]
    let largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
    let prefersScrollingExpandsWhenScrolledToEdge: Bool
    let prefersEdgeAttachedInCompactHeight: Bool
    let cornerRadius: CGFloat
    let backgroundColor: Color
    let prefersGrabberVisible: Bool
    let canDismissSheet: Bool
    
    init(isPresented: Binding<Bool>,
         detents : [UISheetPresentationController.Detent] = [.medium(), .large()],
         largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = .medium,
         prefersScrollingExpandsWhenScrolledToEdge: Bool = false,
         prefersEdgeAttachedInCompactHeight: Bool = true,
         cornerRadius: CGFloat = 12,
         backgroundColor: Color = .black,
         prefersGrabberVisible: Bool = false,
         canDismissSheet: Bool = true,
         @ViewBuilder content: @escaping () -> T) {
        self.sheetContent = content()
        self.detents = detents
        self.largestUndimmedDetentIdentifier = largestUndimmedDetentIdentifier
        self.prefersEdgeAttachedInCompactHeight = prefersEdgeAttachedInCompactHeight
        self.prefersScrollingExpandsWhenScrolledToEdge = prefersScrollingExpandsWhenScrolledToEdge
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.prefersGrabberVisible = prefersGrabberVisible
        self.canDismissSheet = canDismissSheet
        self._isPresented = isPresented
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            CustomSheet_UI(isPresented: $isPresented, detents: detents, largestUndimmedDetentIdentifier: largestUndimmedDetentIdentifier, prefersScrollingExpandsWhenScrolledToEdge: prefersScrollingExpandsWhenScrolledToEdge, prefersEdgeAttachedInCompactHeight: prefersEdgeAttachedInCompactHeight, cornerRadius: cornerRadius, backgroundColor: backgroundColor, prefersGrabberVisible: prefersGrabberVisible, canDismissSheet: canDismissSheet, content: {sheetContent}).frame(width: 0, height: 0)
        }
    }
}

struct CustomSheet_UI<Content: View>: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let content: Content
    let detents : [UISheetPresentationController.Detent]
    let largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
    let prefersScrollingExpandsWhenScrolledToEdge: Bool
    let prefersEdgeAttachedInCompactHeight: Bool
    let cornerRadius: CGFloat
    let backgroundColor: Color
    let prefersGrabberVisible: Bool
    let canDismissSheet: Bool
    
    init(isPresented: Binding<Bool>,
         detents: [UISheetPresentationController.Detent] = [.medium(), .large()],
         largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = .medium,
         prefersScrollingExpandsWhenScrolledToEdge: Bool = false,
         prefersEdgeAttachedInCompactHeight: Bool = true,
         cornerRadius: CGFloat = 12,
         backgroundColor: Color = .black,
         prefersGrabberVisible: Bool = true,
         canDismissSheet: Bool = true,
         @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self.detents = detents
        self.largestUndimmedDetentIdentifier = largestUndimmedDetentIdentifier
        self.prefersEdgeAttachedInCompactHeight = prefersEdgeAttachedInCompactHeight
        self.prefersScrollingExpandsWhenScrolledToEdge = prefersScrollingExpandsWhenScrolledToEdge
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.prefersGrabberVisible = prefersGrabberVisible
        self.canDismissSheet = canDismissSheet
        self._isPresented = isPresented
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> CustomSheetViewController<Content> {
        let vc = CustomSheetViewController(coordinator: context.coordinator,
                                           detents : detents,
                                           largestUndimmedDetentIdentifier: largestUndimmedDetentIdentifier,
                                           prefersScrollingExpandsWhenScrolledToEdge:
                                            prefersScrollingExpandsWhenScrolledToEdge,
                                           prefersEdgeAttachedInCompactHeight:
                                            prefersEdgeAttachedInCompactHeight,
                                           cornerRadius: cornerRadius,
                                           backgroundColor: backgroundColor,
                                           prefersGrabberVisible: prefersGrabberVisible,
                                           canDismissSheet: canDismissSheet,
                                           content: { content })
        return vc
    }
    
    func updateUIViewController(_ uiViewController: CustomSheetViewController<Content>, context: Context) {
        if isPresented {
            uiViewController.presentModalView()
        } else {
            uiViewController.dismissModalView()
        }
    }
    
    class Coordinator: NSObject, UIAdaptivePresentationControllerDelegate {
        var parent: CustomSheet_UI
        init(_ parent: CustomSheet_UI) {
            self.parent = parent
        }
                
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            guard parent.isPresented else { return }
            parent.isPresented = false
        }
    }
}

class CustomSheetViewController<Content: View>: UIViewController {
    let content: Content
    let coordinator: CustomSheet_UI<Content>.Coordinator
    let detents : [UISheetPresentationController.Detent]
    let largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
    let prefersScrollingExpandsWhenScrolledToEdge: Bool
    let prefersEdgeAttachedInCompactHeight: Bool
    let cornerRadius: CGFloat
    let backgroundColor: Color
    let prefersGrabberVisible: Bool
    let canDismissSheet: Bool
    private var isLandscape: Bool = UIDevice.current.orientation.isLandscape
    
    init(coordinator: CustomSheet_UI<Content>.Coordinator,
         detents : [UISheetPresentationController.Detent] = [.medium(), .large()],
         largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = .medium,
         prefersScrollingExpandsWhenScrolledToEdge: Bool = false,
         prefersEdgeAttachedInCompactHeight: Bool = true,
         cornerRadius: CGFloat = 12,
         backgroundColor: Color = .black,
         prefersGrabberVisible: Bool = true,
         canDismissSheet: Bool = true,
         @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self.coordinator = coordinator
        self.detents = detents
        self.largestUndimmedDetentIdentifier = largestUndimmedDetentIdentifier
        self.prefersEdgeAttachedInCompactHeight = prefersEdgeAttachedInCompactHeight
        self.prefersScrollingExpandsWhenScrolledToEdge = prefersScrollingExpandsWhenScrolledToEdge
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.prefersGrabberVisible = prefersGrabberVisible
        self.canDismissSheet = canDismissSheet
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dismissModalView() {
        dismiss(animated: true, completion: nil)
    }
    
    func presentModalView() {
        let hostingController = UIHostingController(rootView: content)
        hostingController.modalPresentationStyle = .popover
        hostingController.isModalInPresentation = !canDismissSheet
        hostingController.presentationController?.delegate = coordinator as UIAdaptivePresentationControllerDelegate
        hostingController.modalTransitionStyle = .coverVertical
        hostingController.view.backgroundColor = UIColor(backgroundColor)
        
        if let hostPopover = hostingController.popoverPresentationController {
            hostPopover.sourceView = super.view
            let sheet = hostPopover.adaptiveSheetPresentationController
            sheet.detents = (isLandscape ? [.large()] : detents)
            sheet.largestUndimmedDetentIdentifier =
            largestUndimmedDetentIdentifier
            sheet.prefersScrollingExpandsWhenScrolledToEdge =
            prefersScrollingExpandsWhenScrolledToEdge
            sheet.prefersEdgeAttachedInCompactHeight =
            prefersEdgeAttachedInCompactHeight
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.preferredCornerRadius = cornerRadius
            sheet.prefersGrabberVisible = prefersGrabberVisible
        }
        
        if presentedViewController == nil {
            present(hostingController, animated: true, completion: nil)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            isLandscape = true
            self.presentedViewController?.popoverPresentationController?.adaptiveSheetPresentationController.detents = [.large()]
        } else {
            isLandscape = false
            self.presentedViewController?.popoverPresentationController?.adaptiveSheetPresentationController.detents = detents
        }
    }
}

extension View {
    func adaptiveSheet<T: View>(isPresented: Binding<Bool>,
                                detents : [UISheetPresentationController.Detent] = [.medium(), .large()],
                                largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = .medium,
                                prefersScrollingExpandsWhenScrolledToEdge: Bool = false,
                                prefersEdgeAttachedInCompactHeight: Bool = true,
                                cornerRadius: CGFloat = 12,
                                backgroundColor: Color = .black,
                                prefersGrabberVisible: Bool = true,
                                canDismissSheet: Bool = true,
                                @ViewBuilder content: @escaping () -> T) -> some View {
        modifier(AdaptiveSheet(isPresented: isPresented,
                               detents: detents,
                               largestUndimmedDetentIdentifier: largestUndimmedDetentIdentifier,
                               prefersScrollingExpandsWhenScrolledToEdge: prefersScrollingExpandsWhenScrolledToEdge,
                               prefersEdgeAttachedInCompactHeight: prefersEdgeAttachedInCompactHeight,
                               cornerRadius: cornerRadius,
                               backgroundColor: backgroundColor,
                               prefersGrabberVisible: prefersGrabberVisible,
                               canDismissSheet: canDismissSheet,
                               content: content))
    }
}
