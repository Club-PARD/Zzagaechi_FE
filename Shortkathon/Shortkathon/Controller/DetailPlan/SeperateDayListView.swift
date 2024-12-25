import UIKit


class SeperateDayListView : UIView {
    //MARK: - property
    var data: [String] = []
    
    let messageLabel : UILabel = {
        let label = UILabel()
        label.text = "요일을 선택하고 세분화 목록을 여기로 드래그 하세요!"
        label.textColor = #colorLiteral(red: 0.7294117647, green: 0.7294117647, blue: 0.7294117647, alpha: 1)
        label.font = UIFont(name: "Pretendard-Regular", size:  12)
        return label
    }()
    
    
    let seperateListTableView : UITableView = {
        let view = UITableView()
        return view
    }()
    
    //MARK: - main
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - function
    func updateUI(){
        if data.isEmpty{
            messageLabel.isHidden = false
            seperateListTableView.isHidden = true
        } else {
            messageLabel.isHidden = true
            seperateListTableView.isHidden = false
        }

    }
    
    func setUI(){
        [messageLabel,seperateListTableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
}
