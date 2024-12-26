import UIKit


class SeperateTaskViewTableCell : UITableViewCell {
    
    //MARK: - property
    
    let taskTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "할 일을 세분화해서 작성"
        textField.font = UIFont(name: "Pretendard-Regular", size: 15)
        textField.textColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    
    
    //MARK: - main
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier:  "ThirdTableCell")
        backgroundColor = .clear
        contentView.backgroundColor = #colorLiteral(red: 0.7760145068, green: 0.8501827121, blue: 0.9661260247, alpha: 1)
        contentView.layer.cornerRadius = 12
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - functions
    func setUI(){
        contentView.addSubview(taskTextField)
        
        NSLayoutConstraint.activate([
            taskTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            taskTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            taskTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            taskTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
