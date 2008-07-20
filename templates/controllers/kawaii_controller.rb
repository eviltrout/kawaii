class KawaiiController < ApplicationController
  
  skip_before_filter :verify_authenticity_token

  # Note you can replace this with your own authentication easily  
  before_filter :replaceable_authentication, :except => :login
  
  AVOID_TABLES = %w(schema_info)

  def index
    @snippets_enabled = KAWAII_OPTIONS[:snippets_enabled]
  end
  
  def snippets
    get_bucket
    @snippets = @bucket.objects
    render :update do |page|
      page.replace_html 'snippets', :partial => 'snippets'
    end
  end
  
  def load_snippet
    get_bucket
    @snippet = @bucket[params[:id]]
    
    render :update do |page|
      page.call 'Kawaii.add_tab', params[:id], @snippet.value
    end
  end
  
  def delete_snippet
    get_bucket
    @snippet = @bucket[params[:id]]
    
    @snippet.delete
    
    snippets
  end
  
  def save_query
    AWS::S3::S3Object.store(params[:snippet_name], params[:query], bucket_name)
    get_bucket
    render :update do |page|
      page.replace_html 'snippets', :partial => 'snippets'
      page.hide 'saving_snippet'
    end
  end
  
  def query
    result = nil
    begin
      result = eval(params[:query])
    rescue Exception => ex
      result = ex.to_s
    end

    formatted = result.too_cute
    if formatted[:type] == "grid"
      schema = []
      formatted[:columns].each do |col|
        col[:resizeable] = true
        schema << col[:key]
      end

      render :update do |page|
        page.call 'Kawaii.show_grid', params[:tab_number], formatted[:columns], schema, formatted[:data]
      end  
    elsif formatted[:type] == "string"
      render :update do |page|
        page.call 'Kawaii.show_string', params[:tab_number], h(formatted[:string])
      end          
    else
      render :update do |page|
        page.alert "Didn't know how to format #{foramtted[:type]}"
      end
    end
  end

  private

  def replaceable_authentication
    
    # Check to make sure it's configured to have a good password
    if KAWAII_OPTIONS[:password] == "CHANGE_ME"
      raise "Change the Kawaii password in /config/initializers/kawaii.rb please!" 
    end
    
    session[:kawaii_password] = params[:kawaii][:password] if params[:kawaii]
    unless session[:kawaii_password] == KAWAII_OPTIONS[:password]
      redirect_to :controller => 'kawaii', :action => 'login'
      return false
    end

    # We set this so we know to show the login link
    @kawaii_authentication = true
  end

  def bucket_name
    KAWAII_OPTIONS[:bucket_name]
  end
  
  def get_bucket
    if KAWAII_OPTIONS[:snippets_enabled]
      begin
        @bucket = AWS::S3::Bucket.find(bucket_name)
      rescue AWS::S3::NoSuchBucket
        @bucket = AWS::S3::Bucket.create(bucket_name)
      end
    end    
  end
end
