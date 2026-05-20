# Frontend Client - Dagsap JNT Internal App

React + Vite frontend application untuk Dagsap dengan UI modern menggunakan React Bootstrap.

## 🎨 Teknologi

- **React 19** - UI Library
- **Vite 8** - Build tool (lightning fast)
- **React Bootstrap 2** - UI Components
- **React Router DOM 7** - Client-side routing
- **Zustand 5** - State management
- **React Hook Form** - Form management
- **Axios** - HTTP client
- **Sass** - CSS preprocessor
- **AG Grid** - Advanced data grid
- **ESLint** - Code linting

## 🏗️ Struktur Project

```
src/
├── api/                # API integration layer
├── assets/             # Static assets (images, fonts, etc)
├── components/         # Reusable components
│   ├── form/          # Form components
│   └── ui/            # UI components (Button, Input, etc)
├── hooks/             # Custom React hooks
├── layouts/           # Page layouts
├── pages/             # Page components
│   └── Auth/          # Authentication pages
├── routes/            # Route definitions
├── services/          # Business logic services
├── stores/            # Zustand stores
├── utils/             # Utility functions
├── App.jsx            # Root component
├── App.css            # Global styles
├── main.jsx           # Entry point
└── index.css          # Global CSS
public/                # Static public files
```

## 🚀 Installation & Setup

```bash
# Install dependencies
npm install

# Setup environment
cp .env.example .env

# Edit .env untuk backend URL
nano .env
```

## 📋 Scripts

```bash
# Development server (dengan HMR)
npm run dev

# Production build
npm run build

# Preview production build locally
npm run preview

# Lint code
npm run lint
```

## 🔑 Environment Variables

Lihat `.env.example` untuk semua variable yang tersedia.

**Penting:**

- `VITE_API_URL` - Base URL untuk backend API
- Semua env variables harus di-prefix dengan `VITE_` untuk accessible di client-side

## 📝 Pages & Routes

### Authentication Pages

- `/auth/login` - Login page
- `/auth/forgot-password` - Forgot password page
- `/auth/change-password` - Change password page

### Dashboard

- `/dashboard` - Main dashboard (protected)

## 🎯 Development Workflow

### 1. Membuat Component Baru

```jsx
// src/components/ui/MyComponent.jsx
export default function MyComponent({ title }) {
  return <div className="my-component">{title}</div>;
}
```

### 2. Membuat Store dengan Zustand

```js
// src/stores/authStore.js
import { create } from "zustand";

const useAuthStore = create((set) => ({
  user: null,
  isAuthenticated: false,
  login: (user) => set({ user, isAuthenticated: true }),
  logout: () => set({ user: null, isAuthenticated: false }),
}));

export default useAuthStore;
```

### 3. Membuat API Service

```js
// src/services/authService.js
import axios from "axios";

const API = axios.create({
  baseURL: import.meta.env.VITE_API_URL,
});

export const authService = {
  login: (email, password) => API.post("/api/auth/login", { email, password }),
  logout: () => API.post("/api/auth/logout"),
  // ...
};
```

### 4. Menggunakan React Router

```jsx
// src/routes/index.jsx
import { createBrowserRouter } from "react-router-dom";
import LoginPage from "../pages/Auth/LoginPage";
import Dashboard from "../layouts/Dashboard";

const router = createBrowserRouter([
  {
    path: "/auth/login",
    element: <LoginPage />,
  },
  {
    path: "/dashboard",
    element: <Dashboard />,
    // protected route
  },
]);

export default router;
```

## 🎨 Styling

Project menggunakan kombinasi:

- **CSS Modules** atau **Sass** untuk component-level styles
- **React Bootstrap** untuk pre-built UI components
- **Global styles** di `src/index.css` dan `src/App.css`

## 🧪 Performance Tips

1. **React Compiler** sudah enabled untuk optimasi otomatis
2. Gunakan `lazy loading` untuk routes yang besar
3. Optimalkan images dengan compression
4. Monitor bundle size dengan `npm run build`

## 🔐 Authentication

Token JWT disimpan dan di-manage via `authStore`:

- Token dikirim di header `Authorization: Bearer <token>`
- Auto-refresh token jika expired
- Logout menghapus token dari store dan storage

## 🚨 Troubleshooting

### Port 5173 sudah digunakan

```bash
# Gunakan port lain
npm run dev -- --port 5174
```

### Environment variables tidak terbaca

- Pastikan di-prefix dengan `VITE_`
- Restart dev server setelah mengubah `.env`
- Akses via `import.meta.env.VITE_VARIABLE_NAME`

### Build error

```bash
# Clear node_modules dan reinstall
rm -rf node_modules package-lock.json
npm install
npm run build
```

## 📚 Resources

- [React Documentation](https://react.dev/)
- [Vite Guide](https://vitejs.dev/guide/)
- [React Bootstrap](https://react-bootstrap.github.io/)
- [React Router](https://reactrouter.com/)
- [Zustand](https://github.com/pmndrs/zustand)
- [React Hook Form](https://react-hook-form.com/)
