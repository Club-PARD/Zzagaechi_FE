import UIKit


class Page4TaskTableViewCell : UITableViewCell {
    
    
    let clearView :  UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cellView : UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1)
        view.layer.borderWidth = 2
        view.layer.borderColor = #colorLiteral(red: 0.6, green: 0.7333333333, blue: 0.9725490196, alpha: 1)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
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
        contentView.addSubview(clearView)
        clearView.addSubview(cellView)
        
        
        [taskLabel].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            cellView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            
            clearView.topAnchor.constraint(equalTo: contentView.topAnchor),
            clearView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            clearView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            clearView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            cellView.topAnchor.constraint(equalTo: clearView.topAnchor,constant: 8),
            cellView.leadingAnchor.constraint(equalTo: clearView.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: clearView.trailingAnchor),
            cellView.bottomAnchor.constraint(equalTo: clearView.bottomAnchor , constant: -8),
            
            taskLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            taskLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant:  21  ),
            
        ])
        
        
    }
}
