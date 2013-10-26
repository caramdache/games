class UIDevice
  def self.ipad?
    currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad
  end
  
  def self.portrait?
    currentDevice.orientation == UIDeviceOrientationPortrait or
    currentDevice.orientation == UIDeviceOrientationPortraitUpsideDown or
    currentDevice.orientation == UIDeviceOrientationUnknown # for the simulator on startup
  end
end