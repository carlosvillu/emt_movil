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
  
  # Muestra un listado de todos los sentidos de la linea
  def sentido
    session[:linea] = params[:id]
    @sentidos = listado "idSentido", {"idLinea" => params[:id]}
    respond_to do |wants|
      wants.movil { render :layout => false }
    end
  end
  
  # Muestra un listado de las paradas del autobus, en ese sentido
  def parada
    session[:sentido] = params[:id]
    @paradas = listado "idParada", {"idLinea" => session[:linea], "idSentido" => params[:id]}
    respond_to do |wants|
      wants.movil { render :layout => false }
    end
  end
  
  # Presenta los tiempo que van a tardar los autobuses que paran en esa parada
  def tiempo
    session[:parada] = params[:id]
    @tiempos = obtener_tiempos "lineacuad", {"idLinea" => session[:linea], "idSentido" => session[:sentido], "idParada" => params[:id]}
    respond_to do |wants|
      wants.movil { render :layout => false }
    end
  end

  private
  
  # Pasandole el 'name' de un atributo select, y después de realizar una consulata a la EMT con los parámetros pasado,
  # parsea el HTML para obtener el listado de 'options' que conforman ese select.
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
  
  # Con todos los parámetros necesarios para realizar una consulta, se parsea el HTML y se obtiene el listado de tiempos de los autobuses que van
  # a parar en la parada seleccionada
  def obtener_tiempos listado, parametros_consulta={}
     res = Net::HTTP.post_form(URI.parse(URL_EMT), parametros_consulta)
     doc = Hpricot(res.body)
     lis = doc.search("li")
     tiempos = []
     lis.each do |li|
       m = /.*\s+(\w?\d*)\s+:\s+(\+?\d*)\w*/.match( li.to_plain_text)
       puts "li => #{li.to_plain_text}"
       puts "Match = #{m}"
       puts "m[1] => #{m[1]}"
       puts "m[2] => #{m[2]}"
       tiempos <<  {"linea" => m[1], "tiempo" => m[2]}
     end
     puts parametros_consulta
     puts tiempos.inspect
     return tiempos
  end
end
