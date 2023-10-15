ALTER SESSION SET CURRENT_SCHEMA = erd;

--1. Zadatak:
select distinct p.NAZIV as ResNaziv from PRAVNO_LICE p
where exists(select * from FIZICKO_LICE fl,LOKACIJA l where
            fl.LOKACIJA_ID = l.LOKACIJA_ID and p.LOKACIJA_ID = fl.LOKACIJA_ID);
--1. Rezultat: 207 provjera
SELECT Sum(Length(ResNaziv)*3) FROM
(select distinct p.NAZIV as ResNaziv from PRAVNO_LICE p
where exists(select * from FIZICKO_LICE fl,LOKACIJA l where
            fl.LOKACIJA_ID = l.LOKACIJA_ID and p.LOKACIJA_ID = fl.LOKACIJA_ID));
--1. Rezultat: 483 slanje
SELECT Sum(Length(ResNaziv)*7) FROM
(select distinct p.NAZIV as ResNaziv from PRAVNO_LICE p
where exists(select * from FIZICKO_LICE fl,LOKACIJA l where
            fl.LOKACIJA_ID = l.LOKACIJA_ID and p.LOKACIJA_ID = fl.LOKACIJA_ID));



--2. Zadatak:
select distinct pl.NAZIV as ResNaziv, TO_CHAR(upl.DATUM_POTPISIVANJA, 'dd.MM.yyyy') as "Datum Potpisivanja"
from PRAVNO_LICE pl, UGOVOR_ZA_PRAVNO_LICE upl
where pl.PRAVNO_LICE_ID = upl.PRAVNO_LICE_ID
and upl.DATUM_POTPISIVANJA > (select min(f.DATUM_KUPOPRODAJE) from FAKTURA f, PROIZVOD p, NARUDZBA_PROIZVODA np
                              where f.FAKTURA_ID = np.FAKTURA_ID
                                and p.PROIZVOD_ID = np.PROIZVOD_ID
                                and p.BROJ_MJESECI_GARANCIJE is not null);
--2. Rezultat: 402 provjera
SELECT Sum(Length(ResNaziv)*3 + Length("Datum Potpisivanja")*3) FROM
(select distinct pl.NAZIV as ResNaziv, TO_CHAR(upl.DATUM_POTPISIVANJA, 'dd.MM.yyyy') as "Datum Potpisivanja"
from PRAVNO_LICE pl, UGOVOR_ZA_PRAVNO_LICE upl
where pl.PRAVNO_LICE_ID = upl.PRAVNO_LICE_ID
and upl.DATUM_POTPISIVANJA > (select min(f.DATUM_KUPOPRODAJE) from FAKTURA f, PROIZVOD p, NARUDZBA_PROIZVODA np
                              where f.FAKTURA_ID = np.FAKTURA_ID
                                and p.PROIZVOD_ID = np.PROIZVOD_ID
                                and p.BROJ_MJESECI_GARANCIJE is not null));
--2. Rezultat: 938 slanje
SELECT Sum(Length(ResNaziv)*7 + Length("Datum Potpisivanja")*7) FROM
(select distinct pl.NAZIV as ResNaziv, TO_CHAR(upl.DATUM_POTPISIVANJA, 'dd.MM.yyyy') as "Datum Potpisivanja"
from PRAVNO_LICE pl, UGOVOR_ZA_PRAVNO_LICE upl
where pl.PRAVNO_LICE_ID = upl.PRAVNO_LICE_ID
and upl.DATUM_POTPISIVANJA > (select min(f.DATUM_KUPOPRODAJE) from FAKTURA f, PROIZVOD p, NARUDZBA_PROIZVODA np
                              where f.FAKTURA_ID = np.FAKTURA_ID
                                and p.PROIZVOD_ID = np.PROIZVOD_ID
                                and p.BROJ_MJESECI_GARANCIJE is not null));



--3. Zadatak:
select * from KATEGORIJA;

select p.NAZIV from PROIZVOD p
where p.KATEGORIJA_ID = any (select p2.KATEGORIJA_ID from PROIZVOD p2, KOLICINA k
                            where p2.PROIZVOD_ID = k.PROIZVOD_ID
                            and k.KOLICINA_PROIZVODA = (select max(k2.KOLICINA_PROIZVODA) from KOLICINA k2));
--3. Rezultat: 51 provjera
SELECT Sum(Length(naziv)*3) FROM
(select p.NAZIV from PROIZVOD p
where p.KATEGORIJA_ID = any (select p2.KATEGORIJA_ID from PROIZVOD p2, KOLICINA k
                            where p2.PROIZVOD_ID = k.PROIZVOD_ID
                            and k.KOLICINA_PROIZVODA = (select max(k2.KOLICINA_PROIZVODA) from KOLICINA k2)));
--3. Rezultat: 119 slanje
SELECT Sum(Length(naziv)*7) FROM
(select p.NAZIV from PROIZVOD p
where p.KATEGORIJA_ID = any (select p2.KATEGORIJA_ID from PROIZVOD p2, KOLICINA k
                            where p2.PROIZVOD_ID = k.PROIZVOD_ID
                            and k.KOLICINA_PROIZVODA = (select max(k2.KOLICINA_PROIZVODA) from KOLICINA k2)));



--4. Zadatak:
select p.NAZIV, pl.NAZIV from PROIZVOD p, PROIZVODJAC pr,PRAVNO_LICE pl
where pl.PRAVNO_LICE_ID = pr.PROIZVODJAC_ID and pr.PROIZVODJAC_ID = p.PROIZVODJAC_ID
and exists(select 'x' from PROIZVOD p2
            where pr.PROIZVODJAC_ID = p2.PROIZVODJAC_ID
            and p2.CIJENA > (select avg(p3.CIJENA) from PROIZVOD p3));
--4. Rezultat: 504 provjera
SELECT Sum(Length("Proizvod")*3 + Length("Proizvodjac")*3) FROM
(select p.NAZIV as "Proizvod", pl.NAZIV as "Proizvodjac" from PROIZVOD p, PROIZVODJAC pr,PRAVNO_LICE pl
where pl.PRAVNO_LICE_ID = pr.PROIZVODJAC_ID and pr.PROIZVODJAC_ID = p.PROIZVODJAC_ID
and exists(select 'x' from PROIZVOD p2
            where pr.PROIZVODJAC_ID = p2.PROIZVODJAC_ID
            and p2.CIJENA > (select avg(p3.CIJENA) from PROIZVOD p3)));
--4. Rezultat: 1176 slanje
SELECT Sum(Length("Proizvod")*7 + Length("Proizvodjac")*7) FROM
(select p.NAZIV as "Proizvod", pl.NAZIV as "Proizvodjac" from PROIZVOD p, PROIZVODJAC pr,PRAVNO_LICE pl
where pl.PRAVNO_LICE_ID = pr.PROIZVODJAC_ID and pr.PROIZVODJAC_ID = p.PROIZVODJAC_ID
and exists(select 'x' from PROIZVOD p2
            where pr.PROIZVODJAC_ID = p2.PROIZVODJAC_ID
            and p2.CIJENA > (select avg(p3.CIJENA) from PROIZVOD p3)));



--5. Zadatak:
select fl.IME || ' ' ||fl.PREZIME as "Ime i prezime", sum(nvl(f.IZNOS,0)) as "iznos" from FIZICKO_LICE fl, KUPAC k, UPOSLENIK u, FAKTURA f
where fl.FIZICKO_LICE_ID = k.KUPAC_ID
and u.UPOSLENIK_ID = fl.FIZICKO_LICE_ID
and f.KUPAC_ID = k.KUPAC_ID
having sum(f.IZNOS) > (select round(avg(sum(f2.IZNOS)),2) from FAKTURA f2, KUPAC k2, FIZICKO_LICE fl2
                                where f2.KUPAC_ID = k2.KUPAC_ID and k2.KUPAC_ID = fl2.FIZICKO_LICE_ID
                                group by fl2.IME, fl2.PREZIME)
group by fl.IME, fl.PREZIME
order by fl.IME, fl.PREZIME;
--5. Rezultat: 6897 provjera
SELECT Sum(Length("Ime i prezime")*3 + "iznos"*3) FROM
(select fl.IME || ' ' ||fl.PREZIME as "Ime i prezime", sum(nvl(f.IZNOS,0)) as "iznos" from FIZICKO_LICE fl, KUPAC k, UPOSLENIK u, FAKTURA f
where fl.FIZICKO_LICE_ID = k.KUPAC_ID
and u.UPOSLENIK_ID = fl.FIZICKO_LICE_ID
and f.KUPAC_ID = k.KUPAC_ID
having sum(f.IZNOS) > (select round(avg(sum(f2.IZNOS)),2) from FAKTURA f2, KUPAC k2, FIZICKO_LICE fl2
                                where f2.KUPAC_ID = k2.KUPAC_ID and k2.KUPAC_ID = fl2.FIZICKO_LICE_ID
                                group by fl2.IME, fl2.PREZIME)
group by fl.IME, fl.PREZIME
order by fl.IME, fl.PREZIME);
--5. Rezultat: 16093 slanje
SELECT Sum(Length("Ime i prezime")*7 + "iznos"*7) FROM
(select fl.IME || ' ' ||fl.PREZIME as "Ime i prezime", sum(nvl(f.IZNOS,0)) as "iznos" from FIZICKO_LICE fl, KUPAC k, UPOSLENIK u, FAKTURA f
where fl.FIZICKO_LICE_ID = k.KUPAC_ID
and u.UPOSLENIK_ID = fl.FIZICKO_LICE_ID
and f.KUPAC_ID = k.KUPAC_ID
having sum(f.IZNOS) > (select round(avg(sum(f2.IZNOS)),2) from FAKTURA f2, KUPAC k2, FIZICKO_LICE fl2
                                where f2.KUPAC_ID = k2.KUPAC_ID and k2.KUPAC_ID = fl2.FIZICKO_LICE_ID
                                group by fl2.IME, fl2.PREZIME)
group by fl.IME, fl.PREZIME
order by fl.IME, fl.PREZIME);



--6. Zadatak:
select pl.NAZIV as "naziv"
from PRAVNO_LICE pl, KURIRSKA_SLUZBA kur, ISPORUKA isp, FAKTURA f, NARUDZBA_PROIZVODA np, POPUST po
where kur.KURIRSKA_SLUZBA_ID = pl.PRAVNO_LICE_ID
and kur.KURIRSKA_SLUZBA_ID = isp.KURIRSKA_SLUZBA_ID
and isp.ISPORUKA_ID = f.ISPORUKA_ID
and f.FAKTURA_ID = np.FAKTURA_ID
and np.POPUST_ID = po.POPUST_ID
and po.POSTOTAK is not null
having sum(np.KOLICINA_JEDNOG_PROIZVODA) in (select max(sum(np2.KOLICINA_JEDNOG_PROIZVODA))
                                            from PRAVNO_LICE pl2, KURIRSKA_SLUZBA kur2, ISPORUKA is2, FAKTURA f2, NARUDZBA_PROIZVODA np2, POPUST po2
                                            where kur2.KURIRSKA_SLUZBA_ID = pl2.PRAVNO_LICE_ID
                                            and kur2.KURIRSKA_SLUZBA_ID = is2.KURIRSKA_SLUZBA_ID
                                            and is2.ISPORUKA_ID = f2.ISPORUKA_ID
                                            and f2.FAKTURA_ID = np2.FAKTURA_ID
                                            and np2.POPUST_ID = po2.POPUST_ID
                                            and po2.POSTOTAK is not null
                                            group by kur2.KURIRSKA_SLUZBA_ID)
group by pl.NAZIV;
--6. Rezultat: 18
SELECT Sum(Length("naziv")*3) FROM
(select pl.NAZIV as "naziv"
from PRAVNO_LICE pl, KURIRSKA_SLUZBA kur, ISPORUKA isp, FAKTURA f, NARUDZBA_PROIZVODA np, POPUST po
where kur.KURIRSKA_SLUZBA_ID = pl.PRAVNO_LICE_ID
and kur.KURIRSKA_SLUZBA_ID = isp.KURIRSKA_SLUZBA_ID
and isp.ISPORUKA_ID = f.ISPORUKA_ID
and f.FAKTURA_ID = np.FAKTURA_ID
and np.POPUST_ID = po.POPUST_ID
and po.POSTOTAK is not null
having sum(np.KOLICINA_JEDNOG_PROIZVODA) in (select max(sum(np2.KOLICINA_JEDNOG_PROIZVODA))
                                            from PRAVNO_LICE pl2, KURIRSKA_SLUZBA kur2, ISPORUKA is2, FAKTURA f2, NARUDZBA_PROIZVODA np2, POPUST po2
                                            where kur2.KURIRSKA_SLUZBA_ID = pl2.PRAVNO_LICE_ID
                                            and kur2.KURIRSKA_SLUZBA_ID = is2.KURIRSKA_SLUZBA_ID
                                            and is2.ISPORUKA_ID = f2.ISPORUKA_ID
                                            and f2.FAKTURA_ID = np2.FAKTURA_ID
                                            and np2.POPUST_ID = po2.POPUST_ID
                                            and po2.POSTOTAK is not null
                                            group by kur2.KURIRSKA_SLUZBA_ID)
group by pl.NAZIV);
--6. Rezultat: 42
SELECT Sum(Length("naziv")*7) FROM
(select pl.NAZIV as "naziv"
from PRAVNO_LICE pl, KURIRSKA_SLUZBA kur, ISPORUKA isp, FAKTURA f, NARUDZBA_PROIZVODA np, POPUST po
where kur.KURIRSKA_SLUZBA_ID = pl.PRAVNO_LICE_ID
and kur.KURIRSKA_SLUZBA_ID = isp.KURIRSKA_SLUZBA_ID
and isp.ISPORUKA_ID = f.ISPORUKA_ID
and f.FAKTURA_ID = np.FAKTURA_ID
and np.POPUST_ID = po.POPUST_ID
and po.POSTOTAK is not null
having sum(np.KOLICINA_JEDNOG_PROIZVODA) in (select max(sum(np2.KOLICINA_JEDNOG_PROIZVODA))
                                            from PRAVNO_LICE pl2, KURIRSKA_SLUZBA kur2, ISPORUKA is2, FAKTURA f2, NARUDZBA_PROIZVODA np2, POPUST po2
                                            where kur2.KURIRSKA_SLUZBA_ID = pl2.PRAVNO_LICE_ID
                                            and kur2.KURIRSKA_SLUZBA_ID = is2.KURIRSKA_SLUZBA_ID
                                            and is2.ISPORUKA_ID = f2.ISPORUKA_ID
                                            and f2.FAKTURA_ID = np2.FAKTURA_ID
                                            and np2.POPUST_ID = po2.POPUST_ID
                                            and po2.POSTOTAK is not null
                                            group by kur2.KURIRSKA_SLUZBA_ID)
group by pl.NAZIV);



--7. Zadatak:
select distinct fl.IME || ' ' || fl.PREZIME as "Kupac", sum(pomocna.Usteda) as "Usteda"
from(select (po2.POSTOTAK/100 * p2.CIJENA * np2.KOLICINA_JEDNOG_PROIZVODA) Usteda, np2.FAKTURA_ID faktura_id
    from POPUST po2, PROIZVOD p2, NARUDZBA_PROIZVODA np2
    where np2.POPUST_ID = po2.POPUST_ID and np2.PROIZVOD_ID = p2.PROIZVOD_ID) pomocna,
FIZICKO_LICE fl, KUPAC k, FAKTURA f
where fl.FIZICKO_LICE_ID = k.KUPAC_ID
and k.KUPAC_ID = f.KUPAC_ID
and f.FAKTURA_ID = pomocna.faktura_id
group by fl.IME || ' ' || fl.PREZIME;
--7. Rezultat: 17709 provjera
SELECT Sum(Length("Kupac")*3 + Round("Usteda")*3) FROM
(select distinct fl.IME || ' ' || fl.PREZIME as "Kupac", sum(pomocna.Usteda) as "Usteda"
from(select (po2.POSTOTAK/100 * p2.CIJENA * np2.KOLICINA_JEDNOG_PROIZVODA) Usteda, np2.FAKTURA_ID faktura_id
    from POPUST po2, PROIZVOD p2, NARUDZBA_PROIZVODA np2
    where np2.POPUST_ID = po2.POPUST_ID and np2.PROIZVOD_ID = p2.PROIZVOD_ID) pomocna,
FIZICKO_LICE fl, KUPAC k, FAKTURA f
where fl.FIZICKO_LICE_ID = k.KUPAC_ID
and k.KUPAC_ID = f.KUPAC_ID
and f.FAKTURA_ID = pomocna.faktura_id
group by fl.IME || ' ' || fl.PREZIME);
--7. Rezultat: 41321 slanje
SELECT Sum(Length("Kupac")*7 + Round("Usteda")*7) FROM
(select distinct fl.IME || ' ' || fl.PREZIME as "Kupac", sum(pomocna.Usteda) as "Usteda"
from(select (po2.POSTOTAK/100 * p2.CIJENA * np2.KOLICINA_JEDNOG_PROIZVODA) Usteda, np2.FAKTURA_ID faktura_id
    from POPUST po2, PROIZVOD p2, NARUDZBA_PROIZVODA np2
    where np2.POPUST_ID = po2.POPUST_ID and np2.PROIZVOD_ID = p2.PROIZVOD_ID) pomocna,
FIZICKO_LICE fl, KUPAC k, FAKTURA f
where fl.FIZICKO_LICE_ID = k.KUPAC_ID
and k.KUPAC_ID = f.KUPAC_ID
and f.FAKTURA_ID = pomocna.faktura_id
group by fl.IME || ' ' || fl.PREZIME);



--8. Zadatak:
select distinct i.ISPORUKA_ID as "idisporuke", i.KURIRSKA_SLUZBA_ID as "idkurirske"
from ISPORUKA i, FAKTURA f, NARUDZBA_PROIZVODA np, POPUST po, PROIZVOD p
where i.ISPORUKA_ID = f.ISPORUKA_ID
and f.FAKTURA_ID = np.FAKTURA_ID
and np.POPUST_ID = po.POPUST_ID
and np.PROIZVOD_ID = p.PROIZVOD_ID
and po.POPUST_ID is not null
and p.BROJ_MJESECI_GARANCIJE > 0;
--8. Rezultat: 243 provjera
 SELECT Sum(idisporuke*3 + idkurirske*3) FROM
(select distinct i.ISPORUKA_ID idisporuke, i.KURIRSKA_SLUZBA_ID idkurirske
from ISPORUKA i, FAKTURA f, NARUDZBA_PROIZVODA np, POPUST po, PROIZVOD p
where i.ISPORUKA_ID = f.ISPORUKA_ID
and f.FAKTURA_ID = np.FAKTURA_ID
and np.POPUST_ID = po.POPUST_ID
and np.PROIZVOD_ID = p.PROIZVOD_ID
and po.POPUST_ID is not null
and p.BROJ_MJESECI_GARANCIJE > 0);
--8. Rezultat: 567 slanje
SELECT Sum(idisporuke*7 + idkurirske*7) FROM
(select distinct i.ISPORUKA_ID idisporuke, i.KURIRSKA_SLUZBA_ID idkurirske
from ISPORUKA i, FAKTURA f, NARUDZBA_PROIZVODA np, POPUST po, PROIZVOD p
where i.ISPORUKA_ID = f.ISPORUKA_ID
and f.FAKTURA_ID = np.FAKTURA_ID
and np.POPUST_ID = po.POPUST_ID
and np.PROIZVOD_ID = p.PROIZVOD_ID
and po.POPUST_ID is not null
and p.BROJ_MJESECI_GARANCIJE > 0);


--9. Zadatak:
select p.NAZIV, p.CIJENA
from PROIZVOD p
where p.CIJENA > (select round(avg(max(p2.CIJENA)),2)
                  from PROIZVOD p2
                  group by p2.KATEGORIJA_ID);
--9. Rezultat: 9210 provjera
 SELECT Sum(Length(naziv)*3 + cijena*3) FROM
(select p.NAZIV, p.CIJENA
from PROIZVOD p
where p.CIJENA > (select round(avg(max(p2.CIJENA)),2)
                  from PROIZVOD p2
                  group by p2.KATEGORIJA_ID));
--9. Rezultat: 21490 slanje
SELECT Sum(Length(naziv)*7 + cijena*7) FROM
(select p.NAZIV, p.CIJENA
from PROIZVOD p
where p.CIJENA > (select round(avg(max(p2.CIJENA)),2)
                  from PROIZVOD p2
                  group by p2.KATEGORIJA_ID));



--10. Zadatak:
select p.NAZIV, p.CIJENA
from PROIZVOD p
where p.CIJENA < all (select avg(p2.CIJENA)
                  from PROIZVOD p2, KATEGORIJA k
                  where p.KATEGORIJA_ID <> k.NADKATEGORIJA_ID
                  and k.KATEGORIJA_ID = p2.KATEGORIJA_ID
                  group by p2.KATEGORIJA_ID);
--10. Rezultat: 2448 provjera
SELECT Sum(Length(naziv)*3 + Round(cijena)*3) FROM
(select p.NAZIV, p.CIJENA
from PROIZVOD p
where p.CIJENA < all (select avg(p2.CIJENA)
                  from PROIZVOD p2, KATEGORIJA k
                  where p.KATEGORIJA_ID <> k.NADKATEGORIJA_ID
                  and k.KATEGORIJA_ID = p2.KATEGORIJA_ID
                  group by p2.KATEGORIJA_ID));
--10. Rezultat: 5712 slanje
SELECT Sum(Length(naziv)*7 + Round(cijena)*7) FROM
(select p.NAZIV, p.CIJENA
from PROIZVOD p
where p.CIJENA < all (select avg(p2.CIJENA)
                  from PROIZVOD p2, KATEGORIJA k
                  where p.KATEGORIJA_ID <> k.NADKATEGORIJA_ID
                  and k.KATEGORIJA_ID = p2.KATEGORIJA_ID
                  group by p2.KATEGORIJA_ID));
