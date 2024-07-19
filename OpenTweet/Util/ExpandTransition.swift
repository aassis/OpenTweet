import UIKit

final class ExpandTransition: NSObject, UIViewControllerAnimatedTransitioning {
    /// We're delcaring this variable to detect if we're pushing or popping a view from the navigation stack
    var popStyle: Bool = false

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if popStyle {
            animatePop(using: transitionContext)
        } else {
            animatePush(using: transitionContext)
        }
    }

    func animatePush(using transitionContext: UIViewControllerContextTransitioning) {
        /// We have to insert the destination view below the origin view, otherwise when the animation goes through, no view will be there to be presented, resulting in a black screen
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!

        /// Scaling the view transform to zero to make it look like it's enlarging when it's transform is set back to it's identity.
        toViewController.view.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        transitionContext.containerView.insertSubview(toViewController.view, aboveSubview: fromViewController.view)

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                /// We animate it back to it's identity
                toViewController.view.transform = .identity
            }, completion: {_ in
                transitionContext.completeTransition(true)
            })
    }

    /// Animation for popping a view
    func animatePop(using transitionContext: UIViewControllerContextTransitioning) {

        /// We retrieve the origin and destination view controllers from the context
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!

        /// We have to insert the destination view below the origin view, otherwise when the animation goes through, no view will be there to be presented, resulting in a black screen
        transitionContext.containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                /**
                 Just transforming to identity wasn't working here, I can't really explain the problem in my own words, but this helpful stackoverflow thread got me to understand how to overcome this issue. It goes deep into explaining CGAffineTransform, some math concepts that went right over my head, but explained to me that by scaling down to zero, the calculation of the shear factor needs to divide by at least one component of the matrix, and since you can't divide by zero, it just sets the components to zero, making the view look like it disappeared rather than making it shrink.
                 https://stackoverflow.com/questions/25964224/cgaffinetransformscale-not-working-with-zero-scale
                 */
                fromViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001)
            }, completion: {_ in
                transitionContext.completeTransition(true)
            })
    }
}
