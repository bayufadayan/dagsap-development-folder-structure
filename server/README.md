# Backend API - Dagsap JNT Internal App

REST API Backend untuk aplikasi Dagsap menggunakan Express.js, Sequelize, dan MySQL.

## 🏗️ Struktur Project

```
src/
├── app.js              # Express app configuration
├── config/             # Database & environment configuration
├── constants/          # Application constants
├── controllers/        # Request handlers
├── database/           # Models, migrations, seeders
├── middlewares/        # Express middlewares
├── routes/             # API routes
├── services/           # Business logic
├── utils/              # Helper utilities
├── validations/        # Input validation
└── tests/              # Test files
public/                 # Static files & uploads
```

## 🚀 Installation

```bash
# Install dependencies
npm install

# Setup environment
cp .env.example .env

# Edit .env dengan konfigurasi database Anda
nano .env
```

## 📋 Scripts

```bash
# Development
npm run dev              # Start with nodemon (auto-restart)

# Production
npm start                # Run production server

# Testing & Quality
npm test                 # Run tests with coverage
npm run format           # Format code with Prettier
```

## 🗄️ Database Setup

```bash
# Create database (based on .env DB_NAME)
npx sequelize-cli db:create

# Run migrations
npx sequelize-cli db:migrate

# Seed database (optional)
npx sequelize-cli db:seed:all

# Create new migration
npx sequelize-cli migration:generate --name migration_name

# Create new model
npx sequelize-cli model:generate --name User --attributes firstName:string,lastName:string
```

## 🔑 Environment Variables

Lihat `.env.example` untuk semua variable yang tersedia.

## 🛣️ API Routes

- `GET /api/health` - Health check
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login
- `POST /api/auth/refresh` - Refresh JWT token
- `POST /api/auth/logout` - User logout
- `POST /api/auth/change-password` - Change password
- `POST /api/auth/forgot-password` - Request password reset

## 🔐 Authentication

Aplikasi menggunakan JWT (JSON Web Tokens) untuk autentikasi.

- Token disimpan di header: `Authorization: Bearer <token>`
- Token expiry configurable via `.env`

## 📁 Public Folder (Uploads)

Folder `public/uploads/` digunakan untuk menyimpan file yang diupload pengguna:

```
public/
└── uploads/
    ├── bucket_1/       # Bucket untuk jenis file tertentu
    ├── bucket_2/
    └── ...
```

## 🧪 Testing

```bash
npm test
```

Test coverage dilaporkan di folder `coverage/`

## 🎨 Code Style

Project menggunakan:

- **Prettier** - Code formatter
- **ESLint** - Code linter

```bash
npm run format           # Format code
```

## 📦 Dependencies

### Production

- **express** - Web framework
- **sequelize** - ORM untuk MySQL
- **mysql2** - MySQL driver
- **jsonwebtoken** - JWT authentication
- **bcryptjs** - Password hashing
- **dotenv** - Environment variables
- **cors** - CORS middleware
- **helmet** - Security headers
- **morgan** - HTTP logging
- **zod** - Schema validation

### Development

- **nodemon** - Auto-restart during development
- **eslint** - Code linting
- **prettier** - Code formatting
- **jest** - Testing framework
- **sequelize-cli** - Database migrations

## 🚨 Troubleshooting

### Database Connection Error

- Pastikan MySQL server running
- Periksa konfigurasi di `.env` (DB_HOST, DB_USER, DB_PASSWORD, DB_NAME)
- Pastikan database sudah dibuat: `npx sequelize-cli db:create`

### Port Sudah Digunakan

- Change `PORT` in `.env` file
- Atau kill process yang menggunakan port tersebut

### Migration Issues

- Reset database: `npx sequelize-cli db:migrate:undo:all`
- Kemudian jalankan lagi: `npx sequelize-cli db:migrate`

## 📝 Notes

- Pastikan menggunakan Node.js 16+ untuk ES Module support
- Database migrations harus dijalankan sebelum menjalankan aplikasi di environment baru
- JWT secret key harus di-set di `.env` untuk production

## 📚 Resources

- [Express Documentation](https://expressjs.com/)
- [Sequelize Documentation](https://sequelize.org/)
- [JWT Documentation](https://jwt.io/)
- [Zod Validation](https://zod.dev/)
