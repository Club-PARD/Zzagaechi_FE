import UIKit

class MainPageViewController : UIViewController {
    var uid = String(describing: UserDefaults.standard.string(forKey: "userIdentifier"))
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        
        print("main: \(uid)")
        

    }
}
