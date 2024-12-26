import UIKit


class DateCollectionViewCell : UICollectionViewCell {
    static let identifier = "DateCollectionViewCell"
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "Pretendard-Regular", size: 20)
        return label
    }()
    
    var dayLabel: UILabel = {
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
    
    override var isSelected: Bool {
            didSet {
                if isSelected {
                    contentView.backgroundColor = #colorLiteral(red: 0.7294117647, green: 0.8117647059, blue: 0.9568627451, alpha: 1)
                    dateLabel.textColor = .black
                    dayLabel.textColor = .black
                } else {
                    contentView.backgroundColor =  #colorLiteral(red: 0.2605186105, green: 0.2605186105, blue: 0.2605186105, alpha: 1)
                    dateLabel.textColor = .white
                    dayLabel.textColor = .white
                }
            }
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

