ALTER SESSION SET CURRENT_SCHEMA = erd;
--KONTINENT, DRZAVA, GRAD, LOKACIJA, FIZICKO_LICE, PRAVNO_LICE, PROIZVODJAC,
--KURIRSKA_SLUZBA, UGOVOR_ZA_PRAVNO_LICE, KUPAC, UPOSLENIK, ODJEL,
--UGOVOR_ZA_UPOSLENIKA, SKLADISTE, KATEGORIJA, POPUST, PROIZVOD, KOLICINA,
--GARANCIJA, ISPORUKA, NARUDZBA_PROIZVODA i FAKTURA

SELECT * FROM KONTINENT;
SELECT * FROM DRZAVA;

--1. Za svaki kontinent prikazati njegove drzave i gradove. Ako kontinent nema drzave ispisati 'Nema drzave' a ako nema grada 'Nema grada'. Kolone nazvati Drzava, Grad i Kontinent
SELECT k.naziv AS Kontinent, Nvl(d.naziv, 'Nema drzave') AS Drzava, Nvl(g.naziv, 'Nema grada') AS Grad
FROM Kontinent k, Drzava d, grad g
WHERE k.kontinent_id = d.kontinent_id(+) AND d.drzava_id = g.drzava_id(+);

--2. Prikazati naziv za sva pravna lica koja su potpisala ugovor izmedju 2014 i 2016. godine (koristiti samo yyyy dio za poredjenje). Potrebno je prikazati rezultate bez ponavljanja
SELECT DISTINCT p.naziv naziv      --(2 IZLAZA)
FROM PRAVNO_LICE p, UGOVOR_ZA_PRAVNO_LICE u
WHERE p.pravno_lice_id=u.pravno_lice_id AND u.datum_potpisivanja BETWEEN To_Date('2014','yyyy') AND To_Date('2016','yyyy');

--3. Za svaku drzavu prikazati kolicinu svakog proizvoda koja se nalazi u skladistima te drzave ako je kolicina proizvoda veca od 50 i naziv drzave ne sadrzi duplo slovo 's'. Kolone nazvati Drzava, Proizvod i Kolicina_proizvoda
SELECT d.naziv AS Drzava, p.naziv AS Proizvod, k.kolicina_proizvoda AS Kolicina_proizvoda
FROM drzava d, proizvod p, kolicina k, lokacija l, grad g, skladiste s
WHERE g.drzava_id = d.drzava_id AND l.grad_id=g.grad_id AND s.lokacija_id = l.lokacija_id AND s.skladiste_id = k.skladiste_id AND k.proizvod_id = p.proizvod_id AND k.kolicina_proizvoda > 50 AND d.naziv NOT LIKE '%s%s%';

--4. Prikazati naziv proizvoda i broj mjeseci garancije za sve proizvode na koje postoji popust a broj mjeseci garancije im je djeljiv sa 3. Potrebno je prikazati rezultate bez ponavljanja
SELECT DISTINCT p.naziv, p.broj_mjeseci_garancije
FROM proizvod p, popust po, narudzba_proizvoda np
WHERE p.proizvod_id = np.proizvod_id AND po.popust_id = np.popust_id AND po.postotak > 0 AND MOD(p.broj_mjeseci_garancije,3) = 0

--5. Prikazati kompletno ime i prezime u jednoj koloni i naziv odjela uposlenika koji je ujedno i kupac proizvoda a nije sef tog odjela. Kao vrijednost trece kolone nadodati vas broj indeksa u svakom redu. Kolone nazvati 'ime i prezime', 'Naziv odjela' i 'Indeks'
SELECT f.ime || ' ' || f.prezime "ime i prezime",
       o.naziv "Naziv odjela"
FROM fizicko_lice f, kupac k, uposlenik u, odjel o
WHERE f.fizicko_lice_id=k.kupac_id AND k.kupac_id=u.uposlenik_id AND u.odjel_id=o.odjel_id AND k.kupac_id!=o.sef_id;

--6. Za sve narudzbe ciji je popust konvertovan u vrijednost cijene manji od 200 prikazati proizvod, cijenu proizvoda i postotak popusta narudzbe kao cijeli broj (od 0 do 100) i kao realni broj (od 0 do 1). Narudzbe koje nemaju popust trebaju biti prikazane kao 0 posto popusta. Nazvati kolone Narudzba_id, Cijena, Postotak i PostotakRealni.
SELECT n.narudzba_id Narudzba_id,
       p.cijena cijena,
       nvl(o.postotak, 0) postotak
FROM narudzba_proizvoda n, proizvod p, popust o
WHERE o.popust_id(+)=n.popust_id AND n.proizvod_id=p.proizvod_id AND (Nvl(o.postotak,0)/100)*p.cijena<200;

--7. Prikazati sve raspolozive kategorije proizvoda i njihove nadkategorije. Ako je id kategorije 1 umjesto naziva kategorije treba pisati 'Komp Oprema' a ako nema kategorije treba pisati 'Nema Kategorije'. Nazvati kolone 'Kategorija' i 'Nadkategorija'
SELECT k1.naziv "Kategorija", Decode(Nvl(k1.nadkategorija_id, 0), 0, 'Nema kategorije', 1 , 'Komp Oprema', k2.naziv) "Nadkategorija"
FROM kategorija k1, kategorija k2
WHERE k1.nadkategorija_id =  k2.kategorija_id(+)

--8. Za svaki ugovor za koji vrijedi da je broj mjeseci od datuma potpisivanja ugovora do 10.10.2020 podijeljen sa 12 veci od dvocifrenog broja sastavljenim od prve dvije cifre kolone Ugovor_id, prikazati koliko je proslo godina, mjeseci i dana od datuma potpisivanja ugovora do 10.10.2020. Ako je proslo 1 godina 2 mjeseca i 3 dana potrebno je ispisati u kolone Godina, Mjeseci i Dana vrijednosti 1, 2 i 3.
SELECT trunc(months_between(To_Date('10.10.2020','dd.mm.yyyy'), upl.datum_potpisivanja) / 12) as Godina
,trunc(mod(months_between(To_Date('10.10.2020','dd.mm.yyyy'), upl.datum_potpisivanja), 12)) as Mjeseci
,trunc(To_Date('10.10.2020','dd.mm.yyyy') - add_months(upl.datum_potpisivanja, trunc(months_between(To_Date('10.10.2020','dd.mm.yyyy'), upl.datum_potpisivanja)))) as Dana
FROM  ugovor_za_pravno_lice upl
WHERE (Months_Between(To_Date('10.01.2020','dd.mm.yyyy'), trunc(upl.datum_potpisivanja)) / 12) >  to_number(SubStr(upl.ugovor_id,0,2))

--9. Prikazati ime i prezime, naziv odjela i id odjela svih uposlenika pri cemu je naziv odjela sa MANAGER ako je u pitanju managment, HUMAN ako su u pitanju ljudski resursi i OTHER za sve ostalo, sortiranih prvo po imenu po rastucem poretku zatim po prezimenu po opadajucem poretku. Kolone nazvati ime prezime, odjel i odjel_id
SELECT f.ime AS ime,  f.prezime AS prezime,
Decode(o.naziv, 'Management', 'MANAGER', 'Human resources', 'HUMAN', 'OTHER') AS odjel
FROM odjel o, uposlenik u, fizicko_lice f
WHERE f.fizicko_lice_id = u.uposlenik_id AND u.odjel_id = o.odjel_id
ORDER BY f.ime ASC , f.prezime DESC

--10. Prikazati svaku kategoriju proizvoda i za svaku kategoriju najskuplji i najjeftiniji proizvod te kategorije i zbir njihovih cijena sortirane po zbiru cijena najjeftinijeg i najskupljeg proizvoda u rastucem poretku. Zbir cijena nazvati ZCijena a proizvode Najjeftiniji i Najskuplji.
SELECT k.naziv, p1.naziv AS Najskuplji, p2.naziv AS Najjefiniji, t1.max_price + t1.min_price AS ZCijena
FROM  (
  SELECT k.naziv AS Category,  Max(cijena) max_price, Min(cijena) min_price
  FROM kategorija k
  INNER JOIN proizvod p ON  p.kategorija_id=k.kategorija_id
  GROUP BY k.naziv
 ) t1
 INNER JOIN kategorija k ON k.naziv = t1.Category
 INNER JOIN proizvod  p1 ON p1.cijena = t1.max_price
 INNER JOIN proizvod  p2 ON p2.cijena = t1.min_price
 ORDER BY ZCijena ASC