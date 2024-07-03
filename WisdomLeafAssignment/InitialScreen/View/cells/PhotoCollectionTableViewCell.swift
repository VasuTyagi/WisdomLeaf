import UIKit

// MARK: - PhotoCollectionTableViewCell
class PhotoCollectionTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var index: Int = 0
    var checkMarkCallback: ((Int) -> Void)?

    // MARK: - UI Components
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0 // Allow multiple lines
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()

    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0 // Allow multiple lines
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()

    let checkBoxButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.tintColor = .label
        return button
    }()

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    // MARK: - Setup Views
    private func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(mainImageView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(checkBoxButton)

        // Setup Auto Layout Constraints
        let padding: CGFloat = 16
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: checkBoxButton.leadingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            checkBoxButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            checkBoxButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            checkBoxButton.widthAnchor.constraint(equalToConstant: 40),
            checkBoxButton.heightAnchor.constraint(equalToConstant: 40),
            
            mainImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            mainImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            mainImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            mainImageView.heightAnchor.constraint(equalToConstant: 200),
            
            descriptionLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: padding),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
        
        // Setup CheckBox Button Action
        checkBoxButton.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
    }

    // MARK: - Actions
    @objc private func checkBoxTapped() {
        checkMarkCallback?(index)
    }

    // MARK: - Configure Cell
    func configure(with photo: Photo) {
        titleLabel.text = photo.author
        descriptionLabel.text = "Size: \(photo.width)x\(photo.height)\nURL: \(photo.url)"
        
        // Placeholder or loading state if image is not available
        mainImageView.image = UIImage(named: "imageViewPlaceHolder")
    }

    func configureCheckMark(isSelected: Bool) {
        let imageName = isSelected ? "checkmark.circle" : "circle"
        checkBoxButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
