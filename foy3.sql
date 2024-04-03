CREATE DATABASE foy3 ON  PRIMARY ( 
NAME = N'foy3', 
FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\foy3.mdf' , 
SIZE = 8MB , 
MAXSIZE = UNLIMITED, 
FILEGROWTH = 10% )
 LOG ON ( 
NAME = N'foy3_log', 
FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\foy3_log.ldf' ,
SIZE = 8MB ,
MAXSIZE = UNLIMITED , 
FILEGROWTH = 10% )

CREATE TABLE birimler
(
    birim_id INT PRIMARY KEY,
    birim_ad CHAR(25) NOT NULL,
);

CREATE TABLE calisanlar
(
    calisan_id INT PRIMARY KEY,
    ad CHAR(25),
    soyad CHAR(25),
    maas INT,
    katilmaTarihi DATETIME,
	calisan_birim_id INT NOT NULL,

	FOREIGN KEY (calisan_birim_id) REFERENCES birimler(birim_id)
);

CREATE TABLE ikramiye
(
    ikramiye_calisan_id INT,
    ikramiye_ucret INT,
    ikramiye_tarih DATETIME,

	FOREIGN KEY (ikramiye_calisan_id) REFERENCES calisanlar(calisan_id)
);

CREATE TABLE unvan
(
    unvan_calisan_id INT,
    unvan_calisan CHAR(25),
    unvan_tarih DATETIME,

	FOREIGN KEY (unvan_calisan_id) REFERENCES calisanlar(calisan_id)
);


INSERT INTO birimler (birim_id, birim_ad)
VALUES
    (1, 'Yazılım'),
    (2, 'Donanım'),
    (3, 'Güvenlik');

INSERT INTO calisanlar (calisan_id, ad, soyad, maas, katilmaTarihi, calisan_birim_id)
VALUES
    (1, 'İsmail', 'İşeri', 100000, '2014-02-20', 1),
    (2, 'Hami', 'Satılmış', 80000, '2014-06-11', 1),
    (3, 'Durmuş', 'Şahin', 300000, '2014-02-20', 2),
    (4, 'Kağan', 'Yazar', 500000, '2014-02-20', 3),
    (5, 'Meryem', 'Soysaldı', 500000, '2014-06-11', 3),
	(6, 'Duygu', 'Akşehir', 200000, '2014-06-11', 2),
	(7, 'Kübra', 'Seyhan', 75000, '2014-01-20', 1),
	(8, 'Gülcan', 'Yıldız', 90000, '2014-04-11', 3);

INSERT INTO ikramiye (ikramiye_calisan_id, ikramiye_ucret, ikramiye_tarih)
VALUES
    (1, 5000, '2016-02-20'),
    (2, 3000, '2016-06-11'),
    (3, 4000, '2016-02-20'),
    (1, 4500, '2016-02-20'),
    (2, 3500, '2016-06-11');

INSERT INTO unvan (unvan_calisan_id, unvan_calisan, unvan_tarih)
VALUES
    (1, 'Yönetici', '2016-02-20'),
    (2, 'Personel', '2016-06-11'),
    (8, 'Personel', '2016-06-11'),
    (5, 'Müdür', '2016-06-11'),
    (4, 'Yönetici Yardımcısı', '2016-06-11'),
	(7, 'Personel', '2016-06-11'),
	(6, 'Takım Lideri', '2016-06-11'),
	(3, 'Takım Lideri', '2016-06-11');



SELECT ad, soyad, maas FROM calisanlar WHERE calisan_birim_id = '1' OR calisan_birim_id = '2'

SELECT ad, soyad, maas FROM calisanlar WHERE maas = ( SELECT MAX(maas) FROM calisanlar )

SELECT birim_ad, COUNT(calisan_birim_id) AS calisan_sayi FROM birimler LEFT JOIN calisanlar ON birim_id = calisan_birim_id GROUP BY birim_ad

SELECT unvan_calisan, COUNT(unvan_calisan_id) AS calisan_sayi FROM unvan LEFT JOIN calisanlar ON calisan_id=unvan_calisan_id GROUP BY unvan_calisan HAVING COUNT(unvan_calisan_id) > 1

SELECT ad, soyad, maas FROM calisanlar WHERE maas BETWEEN 50000 AND 100000

SELECT ad, soyad, maas, birim_ad, unvan_calisan, ikramiye_ucret FROM calisanlar RIGHT JOIN ikramiye ON ikramiye_calisan_id = calisan_id INNER JOIN birimler ON birim_id = calisan_birim_id INNER JOIN unvan ON unvan_calisan_id = calisan_id

SELECT ad, soyad, unvan_calisan FROM unvan LEFT JOIN calisanlar ON calisan_id = unvan_calisan_id WHERE unvan_calisan = 'Yönetici' OR unvan_calisan = 'Müdür'

 SELECT ad, soyad, maas FROM calisanlar INNER JOIN birimler ON birim_id = calisan_birim_id WHERE maas = (SELECT MAX(maas) FROM calisanlar WHERE calisan_birim_id = birim_id)