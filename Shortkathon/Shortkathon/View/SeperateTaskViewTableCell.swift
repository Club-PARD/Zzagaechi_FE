import UIKit


class SeperateTaskViewTableCell : UITableViewCell {
    
    //MARK: - property
    
    let clearView : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let colorView : UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .clear
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 12
        view.layer.borderColor = #colorLiteral(red: 0.7294117647, green: 0.8117647059, blue: 0.9568627451, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let taskTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "어떤 걸 준비해야 하나요?"
        textField.font = UIFont(name: "Pretendard-Regular", size: 15)
        
        textField.textColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isUserInteractionEnabled = true
        textField.backgroundColor = .clear
        return textField
    }()
    
    
    
    //MARK: - main
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier:  "ThirdTableCell")
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        self.isUserInteractionEnabled = true
        self.contentView.isUserInteractionEnabled = true
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - functions
    func setUI(){
        
        contentView.addSubview(clearView)
        clearView.addSubview(colorView)
        colorView.addSubview(taskTextField)
        
        NSLayoutConstraint.activate([
            
            clearView.topAnchor.constraint(equalTo: contentView.topAnchor),
            clearView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            clearView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            clearView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            colorView.topAnchor.constraint(equalTo: clearView.topAnchor , constant: 6 ),
            colorView.bottomAnchor.constraint(equalTo: clearView.bottomAnchor ,constant: -6),
            colorView.leadingAnchor.constraint(equalTo: clearView.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: clearView.trailingAnchor),
        
            taskTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            taskTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            taskTextField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            taskTextField.heightAnchor.constraint(equalToConstant: 40),
            
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        taskTextField.isUserInteractionEnabled = true
    }
}

