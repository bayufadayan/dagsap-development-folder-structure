import AuthLayout from "../../layouts/AuthLayout";
import AuthChangePasswordForm from "../../components/form/AuthChangePasswordForm";

export default function ChangePasswordPage() {
    return (
        <AuthLayout
            title={<>Ubah Password<br />Akun Anda</>}
            description="Gunakan password lama Anda untuk mengatur password baru yang lebih aman."
        >
            <AuthChangePasswordForm />
        </AuthLayout>
    );
}
