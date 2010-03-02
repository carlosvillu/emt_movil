require 'rubygems'
require 'net/http'
require 'uri'
require 'hpricot'

URL_EMT = "http://www.emtmalaga.es/portal/page/portal/EMT/Tiempos%20de%20espera"

res = Net::HTTP.post_form(URI.parse(URL_EMT), {"idLinea" => 4, "idSentido" => 1, "idParada" => 164})
                         
                         
res = Net::HTTP.post_form(URI.parse(URL_EMT), parametros_consulta)
doc = Hpricot(res.body)
lis = doc.search("li")
tiempos = []
lis.each do |li|
 m = /.* (\d*) : (\d*) \w*/.match( li.to_plain_text)
 tiempos <<  {"linea" => m[1], "tiempo" => m[2]}
end
puts tiempos.inspect