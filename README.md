# Dagsap Development Folder Structure

Template folder structure untuk memulai project full-stack dengan frontend React + Vite dan backend Express + Sequelize.

## Struktur

```text
.
├── client/   # Frontend React + Bootstrap
├── server/   # Backend API Express + Sequelize
├── briefs/   # Brief / spesifikasi project
├── setup.sh  # Setup untuk Git Bash / WSL / Linux
├── setup.ps1 # Setup untuk PowerShell
└── setup.bat # Setup untuk CMD
```

## Cara Menjalankan Setup

Asumsi default: pakai **CMD** di Windows.

### 1. CMD

```bat
setup.bat
```

### 2. PowerShell

```powershell
.\setup.ps1
```

### 3. Git Bash / WSL / Linux

```bash
bash setup.sh
```

## Apa yang dilakukan setup script

- meminta nama app dan deskripsi project
- mengubah nama dan deskripsi di `client/package.json` dan `server/package.json`
- menyalin `.env.example` menjadi `.env`
- menjalankan `npm install` di client dan server
- membersihkan file template yang tidak perlu
- menyiapkan project supaya langsung siap dipakai

## Setelah Setup

1. Sesuaikan isi `.env` di `client` dan `server`
2. Jalankan backend dari folder `server`
3. Jalankan frontend dari folder `client`
4. Mulai kembangkan fitur project kamu

## Teknologi

- Backend: Express, Sequelize, MySQL, JWT
- Frontend: React, Vite, Bootstrap, React Hook Form, Zustand

## Catatan Git

Folder upload di server sudah disiapkan agar struktur tetap ikut ke git melalui file `.gitkeep`.
