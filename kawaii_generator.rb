class KawaiiGenerator < Rails::Generator::Base
  attr_accessor :access_key_id, :secret_access_key, :bucket_name

  def manifest
    record do |m|    

      # Initializer
      m.directory File.join('config/initializers')
      m.file "initializers/kawaii.rb", File.join('config/initializers', "kawaii.rb")

      # Config
      m.directory File.join('config')
      m.file "config/kawaii.yml", File.join('config', "kawaii.yml"), :collision => :skip
      
      # Authentication
      m.directory File.join('lib/too_cute')
      m.file 'lib/kawaii_authentication.rb', File.join('lib', "kawaii_authentication.rb"), :collision => :skip
      
      # Too cute handlers
      m.directory File.join('lib/too_cute')      
      m.file 'lib/too_cute/active_record_base_extension.rb', File.join('lib/too_cute', "active_record_base_extension.rb")
      m.file 'lib/too_cute/activerecord_base.rb', File.join('lib/too_cute', "activerecord_base.rb")
      m.file 'lib/too_cute/array.rb', File.join('lib/too_cute', "array.rb")
      m.file 'lib/too_cute/object.rb', File.join('lib/too_cute', "object.rb")
      m.file 'lib/too_cute/hash.rb', File.join('lib/too_cute', "hash.rb")
      m.file 'lib/too_cute/sql_select.rb', File.join('lib/too_cute', "sql_select.rb")
      
      # Controllers
      m.directory File.join('app/controllers')
      m.file 'controllers/kawaii_controller.rb', File.join('app/controllers', "kawaii_controller.rb")
      
      # Local Snippets
      m.directory File.join('app/models')
      m.file 'lib/kawaii_snippets.rb', File.join('lib', 'kawaii_snippets.rb')
      m.file 'models/kawaii_snippet.rb', File.join('app/models', 'kawaii_snippet.rb')
      m.migration_template 'migrations/create_kawaii_snippets.rb', 'db/migrate', {:migration_file_name => 'create_kawaii_snippets'}

      # Views
      m.directory File.join('app/views/kawaii')
      m.file "views/kawaii/_elements.html.erb", File.join('app/views/kawaii', "_elements.html.erb")
      m.file 'views/kawaii/_enumerable.html.erb', File.join('app/views/kawaii', "_enumerable.html.erb")
      m.file 'views/kawaii/_hash.html.erb', File.join('app/views/kawaii', "_hash.html.erb")
      m.file 'views/kawaii/_results.html.erb', File.join('app/views/kawaii', "_results.html.erb")
      m.file 'views/kawaii/_snippets.html.erb', File.join('app/views/kawaii', "_snippets.html.erb")                        
      m.file 'views/kawaii/_table_info.html.erb', File.join('app/views/kawaii', "_table_info.html.erb")                              
      m.file 'views/kawaii/index.html.erb', File.join('app/views/kawaii', "index.html.erb")
      m.file 'views/kawaii/login.html.erb', File.join('app/views/kawaii', "login.html.erb")      

      m.directory File.join('app/views/layouts')      
      m.file "views/layouts/kawaii.html.erb", File.join('app/views/layouts', "kawaii.html.erb")
                        
      # Javascripts
      m.directory File.join('public/javascripts/kawaii')
      m.file 'javascripts/kawaii/datasource-beta-min.js', File.join('public/javascripts/kawaii', "datasource-beta-min.js")
      m.file 'javascripts/kawaii/datatable-beta-min.js', File.join('public/javascripts/kawaii', "datatable-beta-min.js")
      m.file 'javascripts/kawaii/dragdrop-min.js', File.join('public/javascripts/kawaii', "dragdrop-min.js")
      m.file 'javascripts/kawaii/element-beta-min.js', File.join('public/javascripts/kawaii', "element-beta-min.js")
      m.file 'javascripts/kawaii/kawaii.js', File.join('public/javascripts/kawaii', "kawaii.js")
      m.file 'javascripts/kawaii/resize-beta-min.js', File.join('public/javascripts/kawaii', "resize-beta-min.js")
      m.file 'javascripts/kawaii/tabview-min.js', File.join('public/javascripts/kawaii', "tabview-min.js")    
      m.file 'javascripts/kawaii/yahoo-dom-event.js', File.join('public/javascripts/kawaii', "yahoo-dom-event.js")        

      # Stylesheets 
      m.directory File.join('public/stylesheets/kawaii')
      m.file 'stylesheets/kawaii/blankimage.png', File.join('public/stylesheets/kawaii', "blankimage.png")
      m.file 'stylesheets/kawaii/datatable.css', File.join('public/stylesheets/kawaii', "datatable.css")
      m.file 'stylesheets/kawaii/dt-arrow-dn.png', File.join('public/stylesheets/kawaii', "dt-arrow-dn.png")
      m.file 'stylesheets/kawaii/dt-arrow-up.png', File.join('public/stylesheets/kawaii', "dt-arrow-up.png")      
      m.file 'stylesheets/kawaii/fonts-min.css', File.join('public/stylesheets/kawaii', "fonts-min.css")
      m.file 'stylesheets/kawaii/kawaii.css', File.join('public/stylesheets/kawaii', "kawaii.css")      
      m.file 'stylesheets/kawaii/kawaii.png', File.join('public/stylesheets/kawaii', "kawaii.png")            
      m.file 'stylesheets/kawaii/spinner.gif', File.join('public/stylesheets/kawaii', "spinner.gif")      
      m.file 'stylesheets/kawaii/sprite.png', File.join('public/stylesheets/kawaii', "sprite.png")            
      m.file 'stylesheets/kawaii/tabview.css', File.join('public/stylesheets/kawaii', "tabview.css")            
      m.file 'stylesheets/kawaii/transparent.gif', File.join('public/stylesheets/kawaii', "transparent.gif")
      
      # Too cute handlers
    end    
  end

end
