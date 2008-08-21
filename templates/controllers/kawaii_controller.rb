class KawaiiController < ApplicationController
  include KawaiiAuthentication
  
  skip_before_filter :verify_authenticity_token

  # Note you can replace this with your own authentication easily  
  before_filter :replaceable_authentication, :except => :login
  
  AVOID_TABLES = %w(schema_info)

  def index
    @snippets_enabled = KAWAII_OPTIONS['snippets_enabled']
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
    # Perform the query
    result = smart_eval(params[:query])

    # This is in case we are evaluating an ActiveRecord association. It won't have
    # the too_cute method unless we do this first.
    result = result.to_ary if result.kind_of?(Array)
    
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

  def smart_eval(str)
    # If it starts with SELECT, let's try running it as SQL
    if str =~ /\ASELECT(.+)FROM(.+)/im
      conn = ActiveRecord::Base.connection
      result = conn.db_too_cute(str)
    else
      eval(str)
    end
  rescue Exception => ex
    ex.to_s
  end
  
  def bucket_name
    KAWAII_OPTIONS['bucket_name']
  end
  
  def get_bucket
    if KAWAII_OPTIONS['snippets_enabled']
      begin
        @bucket = AWS::S3::Bucket.find(bucket_name)
      rescue AWS::S3::NoSuchBucket
        @bucket = AWS::S3::Bucket.create(bucket_name)
      end
    end    
  end
end
