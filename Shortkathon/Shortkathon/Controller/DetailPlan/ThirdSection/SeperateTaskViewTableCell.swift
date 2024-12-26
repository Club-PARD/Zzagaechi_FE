import UIKit


class SeperateTaskViewTableCell : UITableViewCell {
    
    //MARK: - property
    
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
        contentView.backgroundColor = #colorLiteral(red: 0.7760145068, green: 0.8501827121, blue: 0.9661260247, alpha: 1)
        contentView.layer.cornerRadius = 22.5
        
        self.isUserInteractionEnabled = true
        self.contentView.isUserInteractionEnabled = true
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - functions
    func setUI(){
        contentView.addSubview(taskTextField)
        
        NSLayoutConstraint.activate([
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
