import AuthLayout from "../../layouts/AuthLayout";
import AuthLoginForm from "../../components/form/AuthLoginForm";

export default function LoginPage() {
    return (
        <AuthLayout
            title={<>Selamat Datang,<br />Pengajuan Deposit Konsumen</>}
            description="Silakan masuk ke akun Anda untuk memproses pengajuan deposit konsumen."
        >
            <AuthLoginForm />
        </AuthLayout>
    );
}