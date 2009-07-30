class RemoteIssuesController < ActionController::Base

	include ApplicationHelper
	helper ApplicationHelper

	def create_remotely
			
	@project = Project.find(params[:project_id])
  	
    if @project.nil?      
    	render :json => 'Project not found.'.to_json, :callback => params[:callback]      
    	return
    end
			
	@issue = Issue.new
    @issue.copy_from(params[:copy_from]) if params[:copy_from]
    @issue.project = @project
    # Tracker must be set before custom field values
    @issue.tracker ||= @project.trackers.find((params[:issue] && params[:issue][:tracker_id]) || params[:tracker_id] || :first)
    if @issue.tracker.nil?      
    	render :json => 'No tracker is associated to this project. Please check the Project settings.'.to_json, :callback => params[:callback]      
     	return
    end
    if params[:issue].is_a?(Hash)
    	@issue.attributes = params[:issue]
    	@issue.watcher_user_ids = params[:issue]['watcher_user_ids'] if User.current.allowed_to?(:add_issue_watchers, @project)
    end
    @issue.author = User.current
    
    default_status = IssueStatus.default
    unless default_status      
    	render :json => 'No default issue status is defined. Please check your configuration (Go to "Administration -> Issue statuses").'.to_json, :callback => params[:callback]      
    	return
    end    
    @issue.status = default_status
    @allowed_statuses = ([default_status]).uniq
    
    #if request.get? || request.xhr?
    if params[:callback].nil?
    	@issue.start_date ||= Date.today
    else
		requested_status = IssueStatus.find_by_id(params[:issue][:status_id])
      	# Check that the user is allowed to apply the requested status
      	@issue.status = (@allowed_statuses.include? requested_status) ? requested_status : default_status
      	if @issue.save
	        Mailer.deliver_issue_add(@issue) if Setting.notified_events.include?('issue_added')
    	    render :json => l(:notice_successful_create).to_json, :callback => params[:callback]    
        	return
      	else
    		render :json => @issue.errors.to_json,  :callback => params[:callback]      
      		return      	
      	end		
    end	
    @priorities = Enumeration::get_values('IPRI')
    end
	
end 