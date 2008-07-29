module KawaiiAuthentication

  # This mixin is used to handle the authentication in Kawaii.
  # If you want to add in your own authentication, change the method below
  # to suit your needs.  
  #
  # This module is skipped if you run the generator again to upgrade
  # to the latest version of Kawaii.
  #
  # If you wish to use your own filter-based authentication, just remove
  # the contents of this method and add your filter using the self.included
  # method.
  #
  # example: 
  #   def self.included(base)
  #     base.before_filter :admin_login_required
  #   end
  #
  def replaceable_authentication
    
    # Check to make sure it's configured to have a good password
    if KAWAII_OPTIONS['password'] == "CHANGE_ME"
      raise "Change the Kawaii password in /config/kawaii.yml please!" 
    end
    
    session[:kawaii_password] = params[:kawaii][:password] if params[:kawaii]
    unless session[:kawaii_password] == KAWAII_OPTIONS['password']
      redirect_to :controller => 'kawaii', :action => 'login'
      return false
    end

    # This variable tells Kawaii we're using its authentication, in which case
    # it will show the login form and log out link.
    @kawaii_authentication = true
  end
  
  
end
