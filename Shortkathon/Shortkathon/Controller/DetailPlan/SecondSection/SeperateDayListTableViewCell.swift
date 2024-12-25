import UIKit

class SeperateDayListTableViewCell : UITableViewCell {
    
    //MARK: - property
    
    var taskLabel : UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular" , size:  15)
        label.textColor = .black
        return label
    }()
    
    
    //MARK: - main
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "SecondSectionCell")
        contentView.backgroundColor = #colorLiteral(red: 0.7760145068, green: 0.8501827121, blue: 0.9661260247, alpha: 1)
        contentView.layer.cornerRadius = 20
        setUI()
    }
    

    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - function
    func setUI(){
        [taskLabel].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            taskLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            taskLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor , constant: 24),
            
        
        ])
    }
}
