require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'rho/mapview'
require 'helpers/application_helper'
require 'json'

class DiscountController < Rho::RhoController
  include BrowserHelper
  include ApplicationHelper

  def index
      @@get_result = ""
      
      if Rho::Network.hasNetwork()
        getProps = Hash.new
        getProps['url'] = "http://beardiscounts.herokuapp.com/discounts.json"
        getProps['headers'] = {"Content-Type" => "application/json"}
          
        Rho::Network.get(getProps, url_for(:action => :httpget_callback))
        
        render :action => :wait
        
        else 
           
        Alert.show_popup( {
              :message => 'There was an issue connecting to the Internet. Please reconnect to the network and try again.', 
              :title => 'Connectivity Problems', 
              :buttons => ["OK"],
              } )
      end
   end
    
    def httpget_callback
     #  puts "httpget_callback: #{@params}"
   
       if @params["status"] != 'ok'
           @@error_params = @params
           render_transition(:action => :cancel)
         #  WebView.navigate url_for(:action => :show_error)
       else
         @@get_result = Rho::JSON.parse(@params['body'])
      
       render_transition(:action => :list)
       end
     end 
     
    def get_res
       @@get_result    
     end
     
    def get_error
       @@error_params
     end
    
    
    def show
        @name = @params['name']
        @location = @params['location']
        @phone = @params['phone']
        @image = @params['image']
        @description = @params['description']
        render :action => :show
    end 
     
    def show_error
        render :action => :error, :back => '/app/Json'
      end
      
    def map_it
        @@location = @params['location']
        @@name =  @params['name']
        @@subtitle = @params['description']
        @@url = "maps:q=" + @@location

        if !GeoLocation.known_position?
          # wait till GPS receiver acquire position
          GeoLocation.set_notification( url_for(:action => :map_it_real_good), "")
       #   redirect url_for(:action => :wait)
        else 
     
       puts "got the goods"
        map_params = {
             :provider => 'Google',
             :settings => {:map_type => "hybrid",:region => [38.650038,-90.312199, 0.2, 0.2],
             :zoom_enabled => true,:scroll_enabled => true, :shows_user_location => true, :api_key => 'AIzaSyAN65upd0PEdUCqjv57pa8rTDIG7PmEBzI'},
             :annotations => [
                              {:street_address =>  @@location, :title => @@name, :subtitle => @@subtitle, :url => @@url}
                               ]
        }
        MapView.create map_params
        
      WebView.navigate(:action => :show)
      end
      end
   
    def map_it_real_good
      puts "real good"
      map_params = {
                   :provider => 'Google',
                   :settings => {:map_type => "hybrid",:region => [38.650038,-90.312199, 0.2, 0.2],
                   :zoom_enabled => true,:scroll_enabled => true, :shows_user_location => true, :api_key => 'AIzaSyAN65upd0PEdUCqjv57pa8rTDIG7PmEBzI'},
                   :annotations => [
                                    {:street_address =>  @@location, :title => @@name, :subtitle => @@subtitle, :url => @@url}
                                     ]
              }
              MapView.create map_params
              
      WebView.navigate(:action => :show)
    end
    
    def refresh
      WebView.refresh
    end

    def cancel_httpcall
       Rho::AsyncHttp.cancel( url_for( :action => :httpget_callback) )
       @@get_result  = 'Request was cancelled.'
       render :action => :cancel, :back => '/app'
     end
  
  
  
  # GET /Discount
  def favorite
    @discounts = Discount.find(:all)
    render :action => :favorite
  end

  # GET /Discount/{1}
  def show_favorite
    @discount = Discount.find(@params['id'])
    if @discount
      render :action => :show_favorite, :back => url_for(:action => :favorite)
    else
      redirect :action => :favorite
    end
  end

  # GET /Discount/new
  def new
    @name = @params['name']
    @location = @params['location']
    @description = @params['description']
    @phone = @params['phone']
    @image = @params['image']
      
    @discount = Discount.new
    render :action => :new, :back => url_for(:action => :favorite)
  end

  # GET /Discount/{1}/edit
  def edit
    @discount = Discount.find(@params['id'])
    if @discount
      render :action => :edit, :back => url_for(:action => :favorite)
    else
      redirect :action => :favorite
    end
  end

  # POST /Discount/create
  def create    
    @discount = Discount.create(@params['discount']) #(:name => @name, :location => @location, :phone => @phone, :image => @image)
    Alert.show_popup( {
          :message => 'You have successfully created a favorite. Click on the "Favorites" tab to view your list of favorites.', 
          :title => 'Success!', 
          #:icon => '/public/images/icon.png',
          :buttons => ["OK"],
         # :callback => url_for(:action => :show) 
          } )
      render_transition(:action => :list)
      #redirect :action => :list
  end

  # POST /Discount/{1}/update
  def update
    @discount = Discount.find(@params['id'])
    @discount.update_attributes(@params['discount']) if @discount
    redirect :action => :favorite
  end

  # POST /Discount/{1}/delete
  def delete
    @discount = Discount.find(@params['id'])
    @discount.destroy if @discount
    redirect :action => :favorite
  end
end
