# this file isnt needed anymore
module RemoteTicketSupport #:nodoc:  
	module Routing #:nodoc:  
		module MapperExtensions 
			def create_remotely
				@set.add_route("/projects/:project_id/create_issue_remotely", {:controller => "issues_controller", :action => "create_remotely"})  				
			end  
			
		end  
		
	end 
	
end 
ActionController::Routing::RouteSet::Mapper.send :include, RemoteTicketSupport::Routing::MapperExtensions