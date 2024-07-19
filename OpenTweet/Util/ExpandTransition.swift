import UIKit

final class ExpandTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var popStyle: Bool = false

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if popStyle {
            animatePop(using: transitionContext)
            return
        }

        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!

        toViewController.view.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        transitionContext.containerView.insertSubview(toViewController.view, aboveSubview: fromViewController.view)

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                toViewController.view.transform = .identity
            }, completion: {_ in
                transitionContext.completeTransition(true)
            })
    }

    func animatePop(using transitionContext: UIViewControllerContextTransitioning) {

        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!

        fromViewController.view.transform = .identity
        transitionContext.containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                fromViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001)
            }, completion: {_ in
                transitionContext.completeTransition(true)
            })
    }
}
