ALTER SESSION SET CURRENT_SCHEMA = HM19026;

CREATE table TabelaA(id number,
                     Naziv varchar2(25),
                     Datum DATE,
                     CijeliBroj number constraint cbcheck check(CijeliBroj not between 5 and 15),
                     RealniBroj number constraint rbcheck check (RealniBroj > 5),
                     constraint pktaba primary key (id)
                    );
Create table TabelaB(id number, Naziv varchar2(25),
                     Datum DATE,
                     CijeliBroj number constraint unqcb unique,
                     RealniBroj number,
                     FKTabelaA number constraint nnullb NOT NULL,
                     constraint fktabelaa FOREIGN KEY (FKTabelaA) references TabelaA(id),
                     constraint pktabb primary key (id)
                    );
Create table TabelaC(id number,
                     Naziv varchar2(25),
                     Datum DATE,
                     CijeliBroj number,
                     RealniBroj number,
                     FKTabelaB number,
                     constraint FkCnst FOREIGN KEY (FKTabelaB) references TabelaB(id)
                    );

insert into TabelaA values (1,'tekst',null,null,6.2);
insert into TabelaA values (2,null,null,3,5.26);
insert into TabelaA values (3,'tekst',null,1,null);
insert into TabelaA values (4,null,null,null,null);
insert into TabelaA values (5,'tekst',null,16,6.78);

insert into TabelaB values (1,null,null,1,null,1);
insert into TabelaB values (2,null,null,3,null,1);
insert into TabelaB values (3,null,null,6,null,2);
insert into TabelaB values (4,null,null,11,null,2);
insert into TabelaB values (5,null,null,22,null,3);

insert into TabelaC values (1,'yes',null,33,null,4);
insert into TabelaC values (2,'no',null,33,null,2);
insert into TabelaC values (3,'no',null,55,null,1);

--Izvrsavanje: DA
INSERT INTO TabelaA (id,naziv,datum,cijeliBroj,realniBroj) VALUES (6, 'tekst', NULL, NULL, 6.20);
--Cijeli broj unique
INSERT INTO TabelaB (id,naziv,datum,cijeliBroj,realniBroj,FkTabelaA) VALUES (6, NULL, NULL, 1, NULL, 1);
--Izvrsavanje: DA
INSERT INTO TabelaB (id,naziv,datum,cijeliBroj,realniBroj,FkTabelaA) VALUES (7, NULL, NULL, 123, NULL, 6);
--Izvrsavanje: DA
INSERT INTO TabelaC (id,naziv,datum,cijeliBroj,realniBroj,FkTabelaB) VALUES (4, 'NO', NULL, 55, NULL, NULL);
--Izvrsavanje: DA
UPDATE TabelaA SET naziv = 'tekst' WHERE naziv IS NULL AND cijeliBroj IS NOT NULL;
--jer je foreign key za drugu tabelu C
DROP TABLE TabelaB;
--jer je foreign key za drugu tabelu B
DELETE FROM TabelaA WHERE realniBroj IS NULL;
--Izvrsavanje: DA
DELETE FROM TabelaA WHERE id = 5;
--Izvrsavanje: DA
UPDATE TabelaB SET fktabelaA = 4 WHERE fktabelaA = 2;
--Izvrsavanje: DA
ALTER TABLE tabelaA ADD CONSTRAINT cst CHECK (naziv LIKE 'tekst');

--Rezultati za provjeru:
SELECT SUM(id) FROM TabelaA;
--Rezultat 16
SELECT SUM(id) FROM TabelaB;
--Rezultat 22
SELECT SUM(id) FROM TabelaC;
--Rezultat 10