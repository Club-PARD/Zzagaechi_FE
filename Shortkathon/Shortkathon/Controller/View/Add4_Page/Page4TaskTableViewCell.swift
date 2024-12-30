import UIKit


class Page4TaskTableViewCell : UITableViewCell {
    
    let taskLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()


    //MARK: - 메인
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "page4")
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    

    
    func setUI(){
        
        [taskLabel].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            taskLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            taskLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:  21  ),
            
        ])
        
        
    }
}
