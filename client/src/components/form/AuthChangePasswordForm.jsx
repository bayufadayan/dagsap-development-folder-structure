import { Form } from "react-bootstrap";

export default function AuthChangePasswordForm() {
    return (
        <Form className="auth-form">
            <Form.Group className="mb-3" controlId="currentPassword">
                <Form.Label className="text-white-50 small mb-1 mb-lg-2">
                    Password Lama
                </Form.Label>
                <Form.Control
                    type="password"
                    placeholder="Masukkan password lama"
                    className="auth-input"
                />
            </Form.Group>

            <Form.Group className="mb-3" controlId="newPassword">
                <Form.Label className="text-white-50 small mb-1 mb-lg-2">
                    Password Baru
                </Form.Label>
                <Form.Control
                    type="password"
                    placeholder="Masukkan password baru"
                    className="auth-input"
                />
            </Form.Group>

            <Form.Group className="mb-4" controlId="confirmPassword">
                <Form.Label className="text-white-50 small mb-1 mb-lg-2">
                    Konfirmasi Password Baru
                </Form.Label>
                <Form.Control
                    type="password"
                    placeholder="Ulangi password baru"
                    className="auth-input"
                />
            </Form.Group>

            <button type="submit" className="btn btn-light w-100 auth-button">
                Simpan Password Baru
            </button>
        </Form>
    );
}