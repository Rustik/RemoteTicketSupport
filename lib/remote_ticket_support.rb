# RemoteTicketSupport
=begin
%w{ controllers }.each do |dir| 
	path = File.join(File.dirname(__FILE__), 'app', dir)  
	$LOAD_PATH << path 
	ActiveSupport::Dependencies.load_paths << path 
	ActiveSupport::Dependencies.load_once_paths.delete(path) 	
end 
=end
# doesnt needed since redmine using engines plugin's route inclusion method
#require "remote_ticket_support/routing" 