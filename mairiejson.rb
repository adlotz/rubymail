
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'google_drive'
require 'json'

#fonction Nokogiri qui permet de récuperer les informations de la page http dont on a besoin
page = Nokogiri::HTML(open("http://www.annuaire-des-mairies.com/guyane.html"))

# fonction n°1 qui récupère la liste d'url qui nous sert a alimenter la fonction N°2 
def get_all_the_urls_of_val_doise_townhalls(page)
	urls = []
	page.css('a.lientxt').each do |url|     	
     	url = url['href']
     	url.slice!(0)
     	url = "http://annuaire-des-mairies.com#{url}"
     	urls = urls.push(url)
      	end
     return urls
end 

# fonction n°2 qui recherche l'adresse mail des mairies.
def get_the_email_of_a_townhal_from_its_webpage(page2)
	page3 = Nokogiri::HTML(open(page2))
	adresse = page3.css('//tr[4] td.style27 p.Style22 font')[1]
		return adresse.text[1..-1]
end

# fonction n°3 qui génère la liste des villes qui nous servira a indexer les adresse mail dans le hash
def get_all_the_list_of_town(page)
		list_of_town = []
		page.css('a.lientxt').each do |town|
			town = town.text
			list_of_town = list_of_town.push(town)
		end
		return list_of_town
end

h = Hash.new 

# Appel des fonction n°1 et 3 de listage
listurl = get_all_the_urls_of_val_doise_townhalls(page)
listnom = get_all_the_list_of_town(page)


# boucle qui fait fonctionner la recherche d'adresse mail des mairies et qui l'incorpore dans le hash

count = 0
while count < listnom.length
	mail = get_the_email_of_a_townhal_from_its_webpage(listurl[count])
	h[listnom[count]] = mail
	count += 1
end


# fonction qui génère le fichier en .json
File.open("temp.json","w") do |f|
  f.write(h.to_json)
end

# fonction qui permet d'alimenter le doc spreadsheets google à partir du fichier .json
session = GoogleDrive::Session.from_config("config.json")

ws = session.spreadsheet_by_key("1kDTS5WlluHDlvD84Ww7Q2SNu8CsEo8R-VqgM-AnSYhc").worksheets[0]

ws[1, 1] = "Ville"
ws[1, 2] = "Email"
ws.save

json = File.read('temp.json')
obj = JSON.parse(json)

i = 2
obj.each do |key, val|
ws[i, 1] = key
ws[i, 2] = val
 i += 1
end
end
ws.save