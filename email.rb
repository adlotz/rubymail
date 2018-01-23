require 'google_drive'
require 'gmail'


def send_email_to_line(town,email)
	gmail = Gmail.connect("adlotzy@gmail.com",pasword)
	gmail.deliver do
		to email
		subject "Projet The Hacking Project"
		body get_the_email_html(town)
	end

	gmail.logout
end


def go_trought_all_the_lines
	session = GoogleDrive::Session.from_config("config.json")
	ws = session.spreadsheet_by_key("1kDTS5WlluHDlvD84Ww7Q2SNu8CsEo8R-VqgM-AnSYhc").worksheets[0]
	long = ws.num_rows
	i = 2
	while i <= long
		send_email_to_line(ws[i,1],ws[i,2])
		i += 1
	end
end


def get_the_email_html(town)
	content_type 'text/html; charset=UTF-8'
	return "<p>Bonjour<br/>
	Je m'appelle Adrien, je suis élève à la formation de code gratuite, ouverte à tous, sans restriction géographique, ni restriction de niveau.<br/>

	La formation s'appelle The Hacking Project (http://thehackingproject.org/).<br/>

	Nous apprenons l'informatique via la méthode du peer-learning : nous faisons des projets concrets qui nous sont assignés tous les jours, sur lesquel nous planchons en petites équipes autonomes. 
	Le projet du jours est d'envoyer des emails à nos élus locaux pour qu'ils nous aident à faire de The Hacking Project un nouveau format d'éducation gratuite.<br/>

	Nous vous contactons pour vous parlez du projet, et vous dire que vous pouvez ouvrir une cellule à #{town}, où vous pouvez former gratuitement 6 personnes (ou plus), qu'elles soient débutantes, ou confirmées.
	Le modèle d'éducation de The Hacking Project n'a pas de limite en terme de nombre de moussaillons (c'est comme cela que l'on appel les élèves), donc nous serions ravis de travailler avec #{town} !<br/>

	Charles, co-fondateur de The Hacking Project pourra répondre à toutes vos questions : 06.95.46.60.80.<br/>

	Cordialement Adrien"

end

go_trought_all_the_lines