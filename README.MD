# Cron Dashboard

Dashboard berbasis web sederhana dan ringan untuk memantau serta mengelola **Cron Jobs** di server Linux Anda. Dibangun
menggunakan **Flask**, **Python**, dan **htmx** (implied logic), serta dikelola menggunakan **uv**.

## Fitur

* **Monitoring Real-time**: Melihat daftar cron job yang aktif.
* **Jadwal Eksekusi**: Menghitung waktu eksekusi terakhir dan selanjutnya (Next Run) secara akurat.
* **Manajemen Job**:
    * Tambah Cron Job baru.
    * Edit jadwal dan command.
    * Hapus Cron Job.
    * Enable/Disable Job tanpa menghapusnya.
* **Ringan**: Menggunakan Gunicorn dan Systemd untuk production.

## Teknologi

* [Python 3.13+](https://www.python.org/)
* [Flask](https://flask.palletsprojects.com/)
* [python-crontab](https://pypi.org/project/python-crontab/)
* [uv](https://github.com/astral-sh/uv) (Fast Python package installer)

## Instalasi & Menjalankan (Development)

Pastikan Anda sudah menginstall `uv`.

1. **Clone Repository**
   ```bash
   git clone https://github.com/username/cronDashboard.git
   cd cronDashboard
   ```

2. **Install Dependencies**
   ```bash
   make install
   ```

3. **Jalankan Aplikasi**
   ```bash
   make dev
   ```
   Akses di `http://localhost:9090`.

## Deployment (Production)

Aplikasi ini dilengkapi dengan `Makefile` untuk mengotomatisasi proses deployment menggunakan Gunicorn dan Systemd.

### 1. Install Gunicorn

Pastikan Gunicorn sudah terinstall:

 ```bash
 uv add gunicorn
 ```

### 2. Deploy Otomatis

Jalankan perintah berikut untuk setup folder log, membuat file service systemd, dan menjalankan aplikasi:

 ```bash
 make deploy
 ```

Perintah ini akan:
* Membuat folder log di `/var/log/crondashboard`.
* Membuat konfigurasi systemd service secara otomatis sesuai path project Anda.
* Mengaktifkan dan menjalankan service.

### 3. Manajemen Service

Gunakan perintah berikut untuk mengelola aplikasi:

* **Restart Service** (Gunakan setelah update kode):
   ```bash
   make reload
   ```

* **Cek Log**:
   ```bash
   make logs
   ```

* **Cek Status**:
   ```bash
   make status
   ```

* **Stop Service**:
   ```bash
   make stop
   ```

Akses dashboard di `http://localhost:9090`.

## Keamanan

Aplikasi ini memanipulasi Crontab user secara langsung. Secara default, konfigurasi di atas hanya mengizinkan akses dari
`localhost` (127.0.0.1). Jika ingin diakses dari luar, gunakan VPN atau SSH Tunneling.

## License

MIT