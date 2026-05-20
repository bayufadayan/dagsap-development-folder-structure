import { Form } from "react-bootstrap";

export default function AuthForgotPasswordForm() {
    return (
        <Form className="auth-form">
            <Form.Group className="mb-3" controlId="forgotEmail">
                <Form.Label className="text-white-50 small mb-1 mb-lg-2">
                    Email
                </Form.Label>
                <Form.Control
                    type="email"
                    placeholder="Masukkan email akun Anda"
                    className="auth-input"
                />
            </Form.Group>

            <p className="text-white-50 small mb-4">
                Kami akan mengirimkan tautan untuk mengatur ulang password ke email Anda.
            </p>

            <button type="submit" className="btn btn-light w-100 auth-button">
                Kirim Link Reset
            </button>
        </Form>
    );
}