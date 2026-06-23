import UIKit

class SeriesLoadingView: UIView {
    
    // MARK: - UI Components
    private let containerView = UIView()
    private let spinnerView = UIView()
    private let messageLabel = UILabel()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        // Container
        containerView.backgroundColor = UIColor(white: 0.15, alpha: 1)
        containerView.layer.cornerRadius = 12
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 150),
            containerView.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        // Spinner (animado com CABasicAnimation)
        spinnerView.layer.borderColor = UIColor(red: 1, green: 0.4, blue: 0.2, alpha: 1).cgColor
        spinnerView.layer.borderWidth = 3
        spinnerView.layer.cornerRadius = 35
        spinnerView.backgroundColor = .clear
        containerView.addSubview(spinnerView)
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinnerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            spinnerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            spinnerView.widthAnchor.constraint(equalToConstant: 70),
            spinnerView.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        // Message Label
        messageLabel.text = "Carregando..."
        messageLabel.textColor = .white
        messageLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        messageLabel.textAlignment = .center
        containerView.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: spinnerView.bottomAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8)
        ])
        
        startAnimation()
    }
    
    // MARK: - Animation
    private func startAnimation() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = CGFloat.pi * 2
        rotation.duration = 1.5
        rotation.timingFunction = CAMediaTimingFunction(name: .linear)
        rotation.repeatCount = .infinity
        spinnerView.layer.add(rotation, forKey: "rotation")
    }
    
    // MARK: - Public Methods
    func show(in view: UIView) {
        frame = view.bounds
        view.addSubview(self)
    }
    
    func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    func setMessage(_ message: String) {
        messageLabel.text = message
    }
}
