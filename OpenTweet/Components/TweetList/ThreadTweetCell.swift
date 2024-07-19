import UIKit

final class ThreadTweetCell: TweetCell {

    override func setSelected(_ selected: Bool, animated: Bool) {
        /// Here we are checking to see if the cell which is already selected, was selected (touched) again, so we can dismiss the selection state
        if isSelected && selected {
            super.setSelected(false, animated: animated)
            resetCell()
        } else {
            super.setSelected(selected, animated: animated)

            if selected {
                transformCell()
            } else {
                resetCell()
            }
        }
    }

    private func transformCell() {
        UIView.animate(withDuration: 0.25) {
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
            self.layer.shadowOpacity = 0.3
            self.layer.shadowRadius = 3.0
        }
    }

    private func resetCell() {
        UIView.animate(withDuration: 0.25) {
            self.transform = .identity
            self.layer.shadowOpacity = 0
        }
    }
}
