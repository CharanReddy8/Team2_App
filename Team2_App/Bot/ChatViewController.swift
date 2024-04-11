import UIKit
import SwiftUI

class MyUIKitViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create a UIHostingController with your SwiftUI ContentView
        let hostingController = UIHostingController(rootView: ContentView())

        // Set up frame or constraints for the SwiftUI view
        hostingController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)

        // Add the SwiftUI view as a child view controller
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
}
