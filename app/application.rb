require 'rho/rhoapplication'

class AppApplication < Rho::RhoApplication
  def initialize
    # Tab items are loaded left->right, @tabs[0] is leftmost tab in the tab-bar
    # Super must be called *after* settings @tabs!
    @tabs = {
    #:background_color => 0x0000FF,
    :tabs => [
   # { :label => "Home", :action => '/app', 
   #  :icon => "/public/images/glyphs/glyphicons_020_home.png", :web_bkg_color => 0x7F7F7F }, 
    { :label => "Deals",  :action => '/app/Discount/',  
      :icon => "/public/images/glyphs/glyphicons_156_show_thumbnails.png", :web_bkg_color => 0x7F7F7F },
    { :label => "Favorites",  :action => '/app/Discount/favorite',  
      :icon => "/public/images/glyphs/glyphicons_049_star.png", :web_bkg_color => 0x7F7F7F, :reload => true },
    { :label => "About",  :action => '/app/about.erb',  
      :icon => "/public/images/glyphs/glyphicons_195_circle_info.png", :web_bkg_color => 0x7F7F7F },
    { :label => "Purchase",   :action => '/app/purchase.erb', 
      :icon => "/public/images/glyphs/glyphicons_202_shopping_cart.png", :reload => true, :web_bkg_color => 0x7F7F7F }
    ]
  }
    #To remove default toolbar uncomment next line:
    
    @@toolbar = nil
    super


    # Uncomment to set sync notification callback to /app/Settings/sync_notify.
    # Rho::RhoConnectClient.setObjectNotification("/app/Settings/sync_notify")
 #   Rho::RhoConnectClient.setNotification('*', "/app/Settings/sync_notify", '')

    
  end
end
