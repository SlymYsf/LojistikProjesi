const express = require('express');
const cors = require('cors');
const sql = require('mssql');

const app = express();
app.use(cors());
app.use(express.json());

// MS SQL Veritabanı Bağlantı Ayarları
const config = {
    user: 'sa', // SQL Server kullanıcı adın (Varsayılan: sa)
    password: '123456', // SQL Server şifreni buraya yaz
    server: 'localhost', // Kendi bilgisayarında çalıştığı için localhost
    database: 'db_LojistikOtomasyon',
    options: {
        encrypt: false, // Yerel bağlantı olduğu için şifrelemeye gerek yok
        trustServerCertificate: true
    }
};

// Veritabanına Bağlanma İşlemi
sql.connect(config).then(pool => {
    if(pool.connected) {
        console.log("Mükemmel! MS SQL veritabanına başarıyla bağlandık.");
    }
}).catch(err => {
    console.error("Veritabanı bağlantı hatası:", err.message);
});

// TEST: Ana Sayfaya girildiğinde çalışacak kısım
app.get('/', (req, res) => {
    res.send('Lojistik Otomasyonu API Sunucusu Çalışıyor!');
});

// API: Kargo Takip Listesini Veritabanından Çekip HTML'e Gönderecek Kısım Burası
app.get('/api/kargolar', async (req, res) => {
    try {
        // MS SQL'de yazdığımız o View (Sanal Tablo) yapısından verileri çekiyoruz
        const result = await sql.query('SELECT * FROM vw_KargoTakipListesi');
        res.json(result.recordset); // Verileri JSON formatında (web'in anladığı dil) gönder
    } catch (err) {
        console.error(err);
        res.status(500).send('Veritabanından veriler çekilirken bir hata oluştu.');
    }
});

// Araç Seferlerini (vw_AracSeferListesi) getiren yeni API rotamız
app.get('/api/seferler', async (req, res) => {
    try {
        const havuz = await sql.connect(config);
        const sonuc = await havuz.request().query('SELECT * FROM vw_AracSeferListesi');
        res.json(sonuc.recordset);
    } catch (hata) {
        res.status(500).send('Veritabanı hatası: ' + hata.message);
    }
});

// Kargo durumunu güncelleyen (Stored Procedure çalıştıran) API
app.post('/api/kargo-guncelle', async (req, res) => {
    try {
        const { takipNo, yeniDurum } = req.body; // Tarayıcıdan gelen bilgileri alıyoruz
        
        const havuz = await sql.connect(config);
        
        // sp_KargoDurumGuncelle adlı Stored Procedure'ü çalıştırıyoruz
        await havuz.request()
            .input('TakipNo', sql.NVarChar(20), takipNo)
            .input('YeniDurum', sql.NVarChar(20), yeniDurum)
            .execute('sp_KargoDurumGuncelle'); 
            
        res.json({ basari: true, mesaj: 'Kargo durumu başarıyla güncellendi!' });
    } catch (hata) {
        console.error("Güncelleme hatası:", hata);
        res.status(500).json({ basari: false, mesaj: 'Veritabanı hatası: ' + hata.message });
    }
});

// Sunucuyu 3000 portunda ayağa kaldır
const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Garsonumuz hazır! Sunucu http://localhost:${PORT} adresinde dinliyor.`);
});