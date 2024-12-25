import UIKit


class SeperateDayListView : UIView {
    //MARK: - property
    
    let messageLabel : UILabel() = {
        let label = UILabel()
        
        return label
    }()
    
    
    //MARK: - main
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - function
    func setUI(){
        
    }
}
