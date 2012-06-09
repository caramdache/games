class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    nav = UINavigationController.alloc.initWithRootViewController(GamesController.alloc.init)
    nav.wantsFullScreenLayout = true
    nav.toolbarHidden = true
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = nav
    @window.makeKeyAndVisible
    true
  end
end
