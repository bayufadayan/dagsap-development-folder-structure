import AuthLayout from "../../layouts/AuthLayout";
import AuthForgotPasswordForm from "../../components/form/AuthForgotPasswordForm";

export default function ForgotPasswordPage() {
    return (
        <AuthLayout
            title={<>Lupa Password?<br />Reset Akses Anda</>}
            description="Masukkan email akun Anda untuk menerima tautan reset password."
        >
            <AuthForgotPasswordForm />
        </AuthLayout>
    );
}
