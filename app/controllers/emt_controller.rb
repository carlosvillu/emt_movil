require 'net/http'
require 'uri'
require 'hpricot'


class EmtController < ApplicationController
  layout "app"
  
  URL_EMT = "http://www.emtmalaga.es/portal/page/portal/EMT/Tiempos%20de%20espera"
  
  # Muestra un listado de todas las lineas de autobuses
  def index
    @lineas = listado "idLinea"
  end
  
  def sentido
    session[:linea] = params[:id]
    @sentidos = listado "idSentido", {"idLinea" => params[:id]}
    respond_to do |wants|
      wants.movil { render :layout => false }
    end
  end
  
  def parada
    session[:sentido] = params[:id]
    @paradas = listado "idParada", {"idLinea" => session[:linea], "idSentido" => params[:id]}
    respond_to do |wants|
      wants.movil { render :layout => false }
    end
  end
  
  def tiempo
    session[:parada] = params[:id]
    @tiempos = obtener_tiempos "lineacuad", {"idLinea" => session[:linea], "idSentido" => session[:sentido], "idParada" => params[:id]}
    respond_to do |wants|
      wants.movil { render :layout => false }
    end
  end

  private
  def listado select, parametros_consulta={}
    res = Net::HTTP.post_form(URI.parse(URL_EMT), parametros_consulta)
    doc = Hpricot(res.body)
    options = doc.search("select[@name='#{select}'] option")
    lineas = []
    options.each do |opcion|
      lineas << {"id" => opcion.attributes['value'], "nombre" => opcion.to_plain_text} if opcion.attributes['value'] != "-1"
    end
    return lineas
  end
  
  def obtener_tiempos listado, parametros_consulta={}
     res = Net::HTTP.post_form(URI.parse(URL_EMT), parametros_consulta)
     doc = Hpricot(res.body)
     lis = doc.search("li")
     tiempos = []
     lis.each do |li|
       m = /.* (\d*) : (\d*) \w*/.match( li.to_plain_text)
       tiempos <<  {"linea" => m[1], "tiempo" => m[2]}
     end
     return tiempos
  end
end
