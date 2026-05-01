// Arka Uç (Node.js) sunucumuzdan verileri çeken asıl fonksiyon
async function kargolariGetir() {
    try {
        // Node.js sunucumuza (garsona) bağlanıp verileri istiyoruz
        const response = await fetch('http://localhost:3000/api/kargolar');
        const kargolar = await response.json(); // Gelen JSON'u JavaScript dizisine çeviriyoruz
        
        // HTML'deki tablo gövdesini (kargoGovdesi) buluyoruz
        const tabloGovdesi = document.getElementById('kargoGovdesi');
        tabloGovdesi.innerHTML = ''; // İçindeki "Yükleniyor..." yazısını siliyoruz

        // Gelen her bir kargo verisi için sırayla HTML satırı (tr) oluşturuyoruz
        kargolar.forEach(kargo => {
            // Duruma göre CSS rengini (class'ını) belirliyoruz
            let durumClass = 'durum-depo'; // Varsayılan gri
            if (kargo.Durum === 'Yolda') durumClass = 'durum-yolda';
            else if (kargo.Durum === 'Teslim Edildi') durumClass = 'durum-teslim';
            else if (kargo.Durum === 'Dağıtıma Çıktı' || kargo.Durum === 'Dagitima Çikti') durumClass = 'durum-dagitim';
            else if (kargo.Durum === 'İade Edildi' || kargo.Durum === 'Iade Edildi') durumClass = 'durum-iade';

            // Tablo satırını oluşturuyoruz
            const satir = `
                <tr>
                    <td><strong>${kargo.KargoTakipNo}</strong></td>
                    <td>${kargo.GondericiMusteri}</td>
                    <td>${kargo.Telefon}</td>
                    <td>${kargo.AgirlikKg} kg</td>
                    <td><span class="badge ${durumClass}">${kargo.Durum}</span></td>
                </tr>
            `;
            // Oluşturulan satırı tabloya ekliyoruz
            tabloGovdesi.innerHTML += satir; 
        });
    } catch (error) {
        console.error('Veri çekme hatası:', error);
        document.getElementById('kargoGovdesi').innerHTML = `
            <tr>
                <td colspan="5" style="text-align: center; color: #991b1b; font-weight: bold;">
                    Sunucuya bağlanılamadı! Lütfen VS Code terminalinde "node server.js" komutunun çalıştığından emin olun.
                </td>
            </tr>
        `;
    }
}

// --- Seferleri Getirme Fonksiyonu ---
async function seferleriGetir() {
    try {
        const response = await fetch('http://localhost:3000/api/seferler');
        const seferler = await response.json();
        
        const tabloGovdesi = document.getElementById('seferGovdesi');
        tabloGovdesi.innerHTML = ''; 

        seferler.forEach(sefer => {
            const tarih = new Date(sefer.CikisTarihi).toLocaleString('tr-TR');

            const satir = `
                <tr>
                    <td><strong>#${sefer.SeferID}</strong></td>
                    <td><span class="badge" style="background-color:#e2e8f0; color:#334155; border: 1px solid #cbd5e1;">${sefer.Plaka}</span></td>
                    <td>${sefer.Marka}</td>
                    <td>${sefer.SurucuBilgisi}</td>
                    <td>${sefer.VarisSube}</td>
                    <td>${tarih}</td>
                </tr>
            `;
            tabloGovdesi.innerHTML += satir;
        });
    } catch (error) {
        console.error('Sefer verisi çekme hatası:', error);
        document.getElementById('seferGovdesi').innerHTML = `
            <tr><td colspan="6" style="text-align: center; color: red;">Veriler yüklenemedi!</td></tr>
        `;
    }
}

// Butona basıldığında çalışacak fonksiyon
async function durumDegistir(takipNo) {
    // Kullanıcıya yeni durumu soruyoruz (Basit bir popup ile)
    const yeniDurum = prompt(`${takipNo} numaralı kargo için YENİ DURUMU yazın:\n(Örn: Yolda, Teslim Edildi, Dağıtıma Çıktı, İade Edildi, Depoda Bekliyor)`);
    
    if (yeniDurum) { // Eğer iptale basmadıysa ve bir şey yazdıysa
        try {
            // Node.js'e (garsona) POST isteği atıyoruz
            const response = await fetch('http://localhost:3000/api/kargo-guncelle', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ takipNo: takipNo, yeniDurum: yeniDurum }) // Verileri JSON olarak paketledik
            });
            
            const sonuc = await response.json();
            
            if (sonuc.basari) {
                alert("Başarılı: " + sonuc.mesaj);
                kargolariGetir(); // Tabloyu ekranda anında güncellemek için verileri baştan çekiyoruz
            } else {
                alert("Hata: " + sonuc.mesaj);
            }
        } catch (error) {
            alert("Sunucuya bağlanırken bir hata oluştu!");
        }
    }
}

window.onload = () => {
    // Eğer sayfada kargoGovdesi varsa (kargolar.html sayfasındaysak)
    if (document.getElementById('kargoGovdesi')) {
        kargolariGetir();
    }
    // Eğer sayfada seferGovdesi varsa (seferler.html sayfasındaysak)
    if (document.getElementById('seferGovdesi')) {
        seferleriGetir();
    }
};