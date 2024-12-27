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
        view.backgroundColor = #colorLiteral(red: 0.7760145068, green: 0.8501827121, blue: 0.9661260247, alpha: 1)
        view.layer.cornerRadius = 22.5
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let taskTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "세분화 작성"
        textField.font = UIFont(name: "Pretendard-Regular", size: 15)
        textField.textColor = .black
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

