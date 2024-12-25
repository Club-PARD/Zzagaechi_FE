import UIKit


class DateCollectionViewCell : UICollectionViewCell {
    static let identifier = "DateCollectionViewCell"
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "Pretendard-Regular", size: 20)
        return label
    }()
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "Pretendard-ExtraLight", size: 14)
        return label
    }()
    
    
    
    //MARK: - main
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        contentView.backgroundColor = #colorLiteral(red: 0.2605186105, green: 0.2605186105, blue: 0.2605186105, alpha: 1)
        contentView.layer.cornerRadius = 6
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setUI(){
        [dateLabel, dayLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 17),
            
            dayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dayLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor ,constant: -15)
        ])
    }
}

