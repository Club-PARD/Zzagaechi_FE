
import UIKit

class TaskPlusViewController  : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.1829021573, green: 0.1829021573, blue: 0.1829021573, alpha: 1)
        callModal()
    }
    
    func callModal(){
        let vc = SeparateTaskViewController1()
        vc.modalPresentationStyle = .pageSheet
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        
        
        
        present(vc, animated: true, completion: nil)
    }
    
    
}

