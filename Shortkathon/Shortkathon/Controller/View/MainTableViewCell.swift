import UIKit

class MainTableViewCell : UITableViewCell {
    //MARK: - property
    let taskLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Pretendard-Regular", size: 17)
        return label
    }()
    
    let clearView : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let cellView : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 25.5
        view.layer.borderColor = #colorLiteral(red: 0.7294117647, green: 0.8117647059, blue: 0.9568627451, alpha: 1)
        return view
    }()
    
    //MARK: - main
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "mainTableViewCell")
        self.backgroundColor = .clear
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - function
    func setUI(){
        [taskLabel,clearView,cellView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        contentView.addSubview(clearView)
        clearView.addSubview(cellView)
        cellView.addSubview(taskLabel)
        
        
        NSLayoutConstraint.activate([
            clearView.topAnchor.constraint(equalTo: contentView.topAnchor),
            clearView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            clearView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            clearView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            cellView.leadingAnchor.constraint(equalTo:  clearView.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: clearView.trailingAnchor),
            cellView.topAnchor.constraint(equalTo: clearView.topAnchor, constant: 5),
            cellView.bottomAnchor.constraint(equalTo: clearView.bottomAnchor,constant: -5),
            
            taskLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 57),
            taskLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor)
        ])
        
        
    }
}

