class PagesController < ApplicationController
 require 'dropbox_sdk'
     
  def index
    
  end
  def show
    
    
       flow = DropboxOAuth2FlowNoRedirect.new('s47og90n7ip99ox', '6u8vs2x2sw10e9i')  
    @authorize_url = flow.start()
   
    end
    
  def connect
    if params[:code]
        flow = DropboxOAuth2FlowNoRedirect.new('s47og90n7ip99ox', '6u8vs2x2sw10e9i')
    code = params[:code]
    access_token, user_id = flow.finish(code)
    client = DropboxClient.new(access_token)    
    root_metadata = client.metadata('/website/')
    
    root_metadata['contents'].each do |meta|
      @file = meta['path']
    end
    contents = client.get_file(@file)
    copyfile @file,contents
    end
  end
  def copyfile file,contents
    
    file.slice! '/website'
    username = current_user.email.split('@').first
   
    Dir.mkdir("public\/#{username}") unless File.exists?("public\/#{username}")
     @your_page = "#{username}#{file}"
    open("public\/#{username}#{file}", 'wb') do  |f| 
      f <<  contents 
    end
  end
  
end
