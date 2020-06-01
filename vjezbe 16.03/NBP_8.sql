/*
1. Kreirati bazu podataka publikacije
*/

/*
2. Uvažavajuæi DIJAGRAM uz definiranje primarnih i vanjskih kljuèeva, te veza (relationship) izmeðu tabela, kreirati sljedeæe tabele:

a) autor
	-	autor_ID		cjelobrojna vrijednost	primarni kljuè
	-	autor_ime		15 unicode karaktera	
	-	autor_prezime	20 unicode karaktera	
	-	grad_autora_ID	cjelobrojna vrijednost	
	-	spol			1 karakter	

b) citalac
	-	citalac_ID		cjelobrojna vrijednost	primarni kljuè
	-	citalac_ime		15 unicode karaktera	
	-	citalac_prezime	20 unicode karaktera	
	-	grad_citaoca_ID	cjelobrojna vrijednost	
	-	spol			1 karakter	

c) forma_publikacije
	-	forma_pub_ID	cjelobrojna vrijednost	primarni kljuè
	-	forma_pub_naziv	15 unicode karaktera
	-	max_duz_zadrz	cjelobrojna vrijednost

d) grad
	-	grad_ID			cjelobrojna vrijednost	primarni kljuè
	-	naziv_grada		15 unicode karaktera

e) iznajmljivanje
	-	pub_ID			cjelobrojna vrijednost	primarni kljuè
	-	citalac_ID		15 unicode karaktera	primarni kljuè
	-	dtm_podizanja	datumska vrijednost		primarni kljuè
	-	dtm_vracanja	datumska vrijednost
	-	br_dana_zadr	cjelobrojna vrijednost

f) izdavac
	-	izdavac_ID			cjelobrojna vrijednost	primarni kljuè
	-	grad_izdavaca_ID	cjelobrojna vrijednost
	-	naziv_izdavaca		15 unicode karaktera

g) autor_pub
	-	pub_ID			cjelobrojna vrijednost		primarni kljuè
	-	autor_ID		cjelobrojna vrijednost		primarni kljuè


h) publikacija
	-	pub_ID			cjelobrojna vrijednost		primarni kljuè
	-	naziv_pub		15 unicode karaktera	
	-	vrsta_pub_ID	cjelobrojna vrijednost	
	-	izdavac_ID		cjelobrojna vrijednost	
	-	zanr_ID			cjelobrojna vrijednost	
	-	cijena			decimalna vrijednost oblika 5 - 2	
	-	ISBN			13 unicode karaktera	

i) zanr
	-	zanr_ID			cjelobrojna vrijednost		primarni kljuè
	-	zanr_naziv		15 unicode karaktera
*/
