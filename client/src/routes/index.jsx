import { BrowserRouter, Routes, Route } from "react-router-dom";
import LoginPage from "../pages/Auth/LoginPage";
import ForgotPasswordPage from "../pages/Auth/ForgotPasswordPage";
import ChangePasswordPage from "../pages/Auth/ChangePasswordPage";

export default function AppRoutes() {
  return (
    <BrowserRouter>
        <Routes>
            <Route path="/login" element={<LoginPage />} />
            <Route path="/forgot-password" element={<ForgotPasswordPage />} />
            <Route path="/change-password" element={<ChangePasswordPage />} />
        </Routes>
    </BrowserRouter>
  )
}
