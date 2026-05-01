USE [db_LojistikOtomasyon]
GO
/****** Nesnesi: Table [dbo].[tbl_Musteriler] Betik Tarihi: 30.04.2026 16:17:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Musteriler](
	[MusteriID] [int] IDENTITY(1,1) NOT NULL,
	[TcNo] [nvarchar](11) NOT NULL,
	[Ad] [nvarchar](50) NOT NULL,
	[Soyad] [nvarchar](50) NOT NULL,
	[Telefon] [nvarchar](15) NOT NULL,
	[Sehir] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MusteriID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Nesnesi: Table [dbo].[tbl_Kargolar] Betik Tarihi: 30.04.2026 16:17:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Kargolar](
	[KargoID] [int] IDENTITY(1,1) NOT NULL,
	[KargoTakipNo] [nvarchar](20) NOT NULL,
	[GondericiMusteriID] [int] NOT NULL,
	[SeferID] [int] NULL,
	[AgirlikKg] [decimal](5, 2) NOT NULL,
	[Durum] [nvarchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[KargoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Nesnesi: View [dbo].[vw_KargoTakipListesi] Betik Tarihi: 30.04.2026 16:17:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- vw_KargoTakipListesi adında bir View (Sanal Tablo) oluşturuyoruz
CREATE VIEW [dbo].[vw_KargoTakipListesi] AS
SELECT 
    k.KargoTakipNo,
    m.Ad + ' ' + m.Soyad AS GondericiMusteri, 
    m.Telefon,
    k.AgirlikKg,
    k.Durum
FROM 
    tbl_Kargolar k
INNER JOIN 
    tbl_Musteriler m ON k.GondericiMusteriID = m.MusteriID; 
GO
/****** Nesnesi: Table [dbo].[tbl_Suruculer] Betik Tarihi: 30.04.2026 16:17:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Suruculer](
	[SurucuID] [int] IDENTITY(1,1) NOT NULL,
	[TcNo] [nvarchar](11) NOT NULL,
	[Ad] [nvarchar](50) NOT NULL,
	[Soyad] [nvarchar](50) NOT NULL,
	[EhliyetSinifi] [nvarchar](5) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[SurucuID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Nesnesi: Table [dbo].[tbl_Araclar] Betik Tarihi: 30.04.2026 16:17:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Araclar](
	[AracID] [int] IDENTITY(1,1) NOT NULL,
	[Plaka] [nvarchar](15) NOT NULL,
	[Marka] [nvarchar](50) NOT NULL,
	[KapasiteKg] [decimal](10, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AracID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Nesnesi: Table [dbo].[tbl_Seferler] Betik Tarihi: 30.04.2026 16:17:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Seferler](
	[SeferID] [int] IDENTITY(1,1) NOT NULL,
	[AracID] [int] NOT NULL,
	[SurucuID] [int] NOT NULL,
	[CikisTarihi] [datetime] NOT NULL,
	[VarisSube] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[SeferID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Nesnesi: View [dbo].[vw_AracSeferListesi] Betik Tarihi: 30.04.2026 16:17:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ==========================================
-- 1. EKSİK İKİNCİ VIEW (Görünüm)
-- (Sefere çıkan araçların ve şoförlerin listesi)
-- ==========================================
CREATE VIEW [dbo].[vw_AracSeferListesi] AS
SELECT 
    s.SeferID,
    a.Plaka,
    a.Marka,
    sr.Ad + ' ' + sr.Soyad AS SurucuBilgisi,
    s.VarisSube,
    s.CikisTarihi
FROM tbl_Seferler s
INNER JOIN tbl_Araclar a ON s.AracID = a.AracID
INNER JOIN tbl_Suruculer sr ON s.SurucuID = sr.SurucuID;
GO
/****** Nesnesi: Table [dbo].[tbl_SistemLoglari] Betik Tarihi: 30.04.2026 16:17:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_SistemLoglari](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[IslemTuru] [nvarchar](100) NULL,
	[IslemTarihi] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Nesnesi: Index [UQ__tbl_Arac__830E30F7E5686B33] Betik Tarihi: 30.04.2026 16:17:31 ******/
ALTER TABLE [dbo].[tbl_Araclar] ADD UNIQUE NONCLUSTERED 
(
	[Plaka] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Nesnesi: Index [UQ__tbl_Karg__CB3B4798336079F0] Betik Tarihi: 30.04.2026 16:17:31 ******/
ALTER TABLE [dbo].[tbl_Kargolar] ADD UNIQUE NONCLUSTERED 
(
	[KargoTakipNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Nesnesi: Index [IX_KargoDurumArama] Betik Tarihi: 30.04.2026 16:17:31 ******/
CREATE NONCLUSTERED INDEX [IX_KargoDurumArama] ON [dbo].[tbl_Kargolar]
(
	[Durum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Nesnesi: Index [UQ__tbl_Must__8EF935A61B2A90C7] Betik Tarihi: 30.04.2026 16:17:31 ******/
ALTER TABLE [dbo].[tbl_Musteriler] ADD UNIQUE NONCLUSTERED 
(
	[TcNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Nesnesi: Index [IX_MusteriSehirArama] Betik Tarihi: 30.04.2026 16:17:31 ******/
CREATE NONCLUSTERED INDEX [IX_MusteriSehirArama] ON [dbo].[tbl_Musteriler]
(
	[Sehir] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Nesnesi: Index [UQ__tbl_Suru__8EF935A6DCF723FB] Betik Tarihi: 30.04.2026 16:17:31 ******/
ALTER TABLE [dbo].[tbl_Suruculer] ADD UNIQUE NONCLUSTERED 
(
	[TcNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Kargolar] ADD  DEFAULT ('Depoda Bekliyor') FOR [Durum]
GO
ALTER TABLE [dbo].[tbl_Seferler] ADD  DEFAULT (getdate()) FOR [CikisTarihi]
GO
ALTER TABLE [dbo].[tbl_SistemLoglari] ADD  DEFAULT (getdate()) FOR [IslemTarihi]
GO
ALTER TABLE [dbo].[tbl_Kargolar]  WITH CHECK ADD FOREIGN KEY([GondericiMusteriID])
REFERENCES [dbo].[tbl_Musteriler] ([MusteriID])
GO
ALTER TABLE [dbo].[tbl_Kargolar]  WITH CHECK ADD FOREIGN KEY([SeferID])
REFERENCES [dbo].[tbl_Seferler] ([SeferID])
GO
ALTER TABLE [dbo].[tbl_Seferler]  WITH CHECK ADD FOREIGN KEY([AracID])
REFERENCES [dbo].[tbl_Araclar] ([AracID])
GO
ALTER TABLE [dbo].[tbl_Seferler]  WITH CHECK ADD FOREIGN KEY([SurucuID])
REFERENCES [dbo].[tbl_Suruculer] ([SurucuID])
GO
ALTER TABLE [dbo].[tbl_Araclar]  WITH CHECK ADD CHECK  (([KapasiteKg]>(0)))
GO
ALTER TABLE [dbo].[tbl_Kargolar]  WITH CHECK ADD CHECK  (([AgirlikKg]>(0)))
GO
/****** Nesnesi: StoredProcedure [dbo].[sp_YeniAracEkle] Betik Tarihi: 30.04.2026 16:17:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ==========================================
-- 2. EKSİK İKİNCİ STORED PROCEDURE (Saklı Yordam)
-- (Sisteme güvenli bir şekilde yeni araç ekleme yordamı)
-- ==========================================
CREATE PROCEDURE [dbo].[sp_YeniAracEkle]
    @Plaka NVARCHAR(15),
    @Marka NVARCHAR(50),
    @Kapasite DECIMAL(10,2)
AS
BEGIN
    INSERT INTO tbl_Araclar (Plaka, Marka, KapasiteKg)
    VALUES (@Plaka, @Marka, @Kapasite);
END;
GO
/****** Nesnesi: Trigger [dbo].[trg_KargoSilinmeLog] Betik Tarihi: 30.04.2026 16:17:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Trigger 2: Bir kargo kaydı silindiğinde otomatik log tutar
CREATE TRIGGER [dbo].[trg_KargoSilinmeLog]
ON [dbo].[tbl_Kargolar]
AFTER DELETE
AS
BEGIN
    INSERT INTO tbl_SistemLoglari (IslemTuru)
    VALUES ('Sistemden bir kargo kaydı silindi!');
END;
GO
ALTER TABLE [dbo].[tbl_Kargolar] ENABLE TRIGGER [trg_KargoSilinmeLog]
GO
/****** Nesnesi: Trigger [dbo].[trg_YeniMusteriLog] Betik Tarihi: 30.04.2026 16:17:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Trigger 1: Yeni bir müşteri eklendiğinde otomatik log tutar
CREATE TRIGGER [dbo].[trg_YeniMusteriLog]
ON [dbo].[tbl_Musteriler]
AFTER INSERT
AS
BEGIN
    INSERT INTO tbl_SistemLoglari (IslemTuru)
    VALUES ('Sisteme yeni bir müşteri kaydı eklendi.');
END;
GO
ALTER TABLE [dbo].[tbl_Musteriler] ENABLE TRIGGER [trg_YeniMusteriLog]
GO
-- ==========================================
-- EKSİK KALAN 1. PROSEDÜRÜN EKLENMESİ
-- ==========================================
CREATE PROCEDURE [dbo].[sp_KargoDurumGuncelle]
    @TakipNo NVARCHAR(20),  
    @YeniDurum NVARCHAR(20) 
AS
BEGIN
    UPDATE tbl_Kargolar SET Durum = @YeniDurum WHERE KargoTakipNo = @TakipNo;
END;
GO

INSERT INTO tbl_Musteriler (TcNo, Ad, Soyad, Telefon, Sehir) VALUES
('11111111110', 'Ahmet', 'Yılmaz', '05551112233', 'İstanbul'), ('22222222220', 'Ayşe', 'Kaya', '05322223344', 'Ankara'), ('33333333330', 'Mehmet', 'Demir', '05443334455', 'İzmir'), ('44444444440', 'Fatma', 'Çelik', '05554445566', 'Bursa'), ('55555555550', 'Mustafa', 'Şahin', '05325556677', 'Antalya'), ('66666666660', 'Zeynep', 'Yıldız', '05446667788', 'Adana'), ('77777777770', 'Ali', 'Öztürk', '05557778899', 'Konya'), ('88888888880', 'Elif', 'Aydın', '05328889900', 'Kocaeli'), ('99999999990', 'Hüseyin', 'Arslan', '05449990011', 'Gaziantep'), ('10101010100', 'Merve', 'Doğan', '05551012030', 'Kayseri');

INSERT INTO tbl_Suruculer (TcNo, Ad, Soyad, EhliyetSinifi) VALUES
('12121212120', 'Hasan', 'Güler', 'CE'), ('13131313130', 'Kemal', 'Taş', 'C'), ('14141414140', 'Osman', 'Ak', 'CE'), ('15151515150', 'Cemal', 'Kara', 'C'), ('16161616160', 'Nuri', 'Sarı', 'CE'), ('17171717170', 'Orhan', 'Mavi', 'C'), ('18181818180', 'Bekir', 'Boz', 'CE'), ('19191919190', 'Yakup', 'Tunç', 'C'), ('20202020200', 'Serkan', 'Gümüş', 'CE'), ('21212121210', 'Emre', 'Altın', 'C');

INSERT INTO tbl_Araclar (Plaka, Marka, KapasiteKg) VALUES
('34 ABC 123', 'Ford Trucks', 15000.00), ('06 DEF 456', 'Mercedes-Benz', 20000.00), ('35 GHI 789', 'Volvo', 25000.00), ('16 JKL 012', 'Scania', 22000.00), ('07 MNO 345', 'MAN', 18000.00), ('01 PQR 678', 'Renault Trucks', 16000.00), ('42 STU 901', 'Iveco', 14000.00), ('41 VWX 234', 'DAF', 19000.00), ('27 YZA 567', 'BMC', 12000.00), ('38 BCD 890', 'Isuzu', 8000.00);

INSERT INTO tbl_Seferler (AracID, SurucuID, VarisSube) VALUES
(1, 1, 'Ankara Merkez Sube'), (2, 2, 'İzmir Bornova Sube'), (3, 3, 'Bursa Nilüfer Sube'), (4, 4, 'Antalya Muratpaşa Sube'), (5, 5, 'Adana Seyhan Sube'), (6, 6, 'Konya Selçuklu Sube'), (7, 7, 'Kocaeli İzmit Sube'), (8, 8, 'Gaziantep Şahinbey Sube'), (9, 9, 'Kayseri Melikgazi Sube'), (10, 10, 'İstanbul Kadıköy Sube');

INSERT INTO tbl_Kargolar (KargoTakipNo, GondericiMusteriID, SeferID, AgirlikKg, Durum) VALUES
('TRK-000000001', 1, 1, 50.50, 'Yolda'), ('TRK-000000002', 2, 2, 120.00, 'Yolda'), ('TRK-000000003', 3, 3, 25.75, 'Teslim Edildi'), ('TRK-000000004', 4, 4, 8.20, 'Yolda'), ('TRK-000000005', 5, 5, 450.00, 'Yolda'), ('TRK-000000006', 6, 6, 15.00, 'Dağıtıma Çıktı'), ('TRK-000000007', 7, 7, 75.50, 'Yolda'), ('TRK-000000008', 8, 8, 200.00, 'Depoda Bekliyor'), ('TRK-000000009', 9, 9, 5.10, 'İade Edildi'), ('TRK-000000010', 10, 10, 32.00, 'Yolda');
GO