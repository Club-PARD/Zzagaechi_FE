import UIKit

class MainViewController : UIViewController {
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1)
    }
}

