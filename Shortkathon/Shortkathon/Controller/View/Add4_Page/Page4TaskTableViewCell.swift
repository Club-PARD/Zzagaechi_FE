
import UIKit

protocol Page4TaskTableViewCellDelegate: AnyObject {
    func didTapAddButton(in cell: Page4TaskTableViewCell)
}

class Page4TaskTableViewCell : UITableViewCell {
    weak var delegate: Page4TaskTableViewCellDelegate?
    
    private let gradientLayer: CAGradientLayer = {
           let layer = CAGradientLayer()
           layer.colors = [
               UIColor(red: 0.529, green: 0.698, blue: 1.0, alpha: 1.0).cgColor, // #87B2FF
               UIColor(red: 0.447, green: 0.643, blue: 1.0, alpha: 1.0).cgColor  // #72A4FF
           ]
           layer.locations = [0.0, 1.0]
           layer.startPoint = CGPoint(x: 0.0, y: 0.0)
           layer.endPoint = CGPoint(x: 0.5, y: 1.0)
           layer.cornerRadius = 12  // 셀의 모서리를 둥글게
           return layer
       }()
    
    
    
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
        view.layer.borderColor = #colorLiteral(red: 0.4196078431, green: 0.631372549, blue: 1, alpha: 1)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    let taskLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        return label
    }()
    
    let addButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "rightButton"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.imageView?.clipsToBounds = true
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside) // 타깃 설정

        return button
    }()
    
    let clockButton : UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setImage(UIImage(named: "clock"), for:  .normal)
        return button
    }()

    let blueView : UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.4196078431, green: 0.631372549, blue: 1, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let dateLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "날짜"
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    let timeLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "시간"
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - 메인
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "page4")
        setUI()
        contentView.layer.insertSublayer(gradientLayer, at: 0)
        selectionStyle = .none

    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    func setUI(){
        contentView.addSubview(clearView)
        clearView.addSubview(cellView)
        blueView.addSubview(dateLabel)
        blueView.addSubview(timeLabel)
        
        [taskLabel,clockButton,addButton,blueView].forEach{
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
            
//            taskLabel.topAnchor.constraint(equalTo: cellView.topAnchor ,constant: 18),
            taskLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant:  16  ),
            taskLabel.bottomAnchor.constraint(equalTo: blueView.topAnchor, constant: -8),
            
            
            addButton.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 11),
            addButton.trailingAnchor.constraint(equalTo: cellView.trailingAnchor,constant: -11),
            addButton.widthAnchor.constraint(equalToConstant: 10),
            addButton.heightAnchor.constraint(equalToConstant: 20),
        
            blueView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor),
            blueView.trailingAnchor.constraint(equalTo: cellView.trailingAnchor),
            blueView.heightAnchor.constraint(equalToConstant: 50 ),
            blueView.bottomAnchor.constraint(equalTo:cellView.bottomAnchor),
//            blueView.topAnchor.constraint(equalTo: taskLabel.bottomAnchor, constant: 9),
            
            dateLabel.topAnchor.constraint(equalTo: blueView.topAnchor,constant: 13),
            dateLabel.leadingAnchor.constraint(equalTo: blueView.leadingAnchor, constant: 16),
            
            timeLabel.topAnchor.constraint(equalTo: blueView.topAnchor,constant: 13),
            timeLabel.leadingAnchor.constraint(equalTo: blueView.leadingAnchor,constant: 181),
        ])
        
        
    }
    
       @objc private func addButtonTapped() {
           delegate?.didTapAddButton(in: self)
       }

    override func layoutSubviews() {
            super.layoutSubviews()
            gradientLayer.frame = contentView.bounds
            // 하단만 cornerRadius 설정
            let cornerRadius: CGFloat = 12
            let maskPath = UIBezierPath(
                roundedRect: blueView.bounds,
                byRoundingCorners: [.bottomLeft, .bottomRight], // 하단만 둥글게
                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
            )
            let shape = CAShapeLayer()
            shape.path = maskPath.cgPath
            blueView.layer.mask = shape
        }
}


