//
//  MapOverlay.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-08-01.
//

import Foundation
import UIKit
import SwiftUI

class OverlayViewController: UIViewController {
    private let overlayView: UIHostingController<OverlayView>
    
    init() {
        self.overlayView = UIHostingController(rootView: OverlayView())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let overlayView = overlayView.view else { return }
        overlayView.frame = view.bounds
        view.addSubview(overlayView)
        overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}

struct OverlayViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> OverlayViewController {
        return OverlayViewController()
    }
    
    func updateUIViewController(_ uiViewController: OverlayViewController, context: Context) {
        // Update the view controller if needed
    }
}

struct OverlayView: View {
    var body: some View {
        VStack {
            Text("Overlay Content")
                .font(.largeTitle)
                .foregroundColor(.white)
            Spacer()
        }
        .background(Color.black.opacity(0.6))
        .edgesIgnoringSafeArea(.all)
    }
}
