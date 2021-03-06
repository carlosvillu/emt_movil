# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  before_filter :movil?

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  private
  
  # Si es un dispositivo móvil, el formato de respuesta cambia
  # de esta forma nos ahoramos tener que usar subdominios para la misma funcionalidad.
  def movil?
    request.format = :movil if  request.user_agent =~ /Mobile|webOS/ && !request.xhr?
  end
end
