import { Form } from "react-bootstrap";

export default function AuthLoginForm() {
    return (
        <Form className="auth-form">
            <Form.Group className="mb-2 mb-lg-3" controlId="authEmail">
                <Form.Label className="text-white-50 small mb-1 mb-lg-2">Email</Form.Label>
                <Form.Control
                    type="email"
                    placeholder="Masukkan email Anda"
                    className="auth-input"
                />
            </Form.Group>

            <Form.Group className="mb-2" controlId="authPassword">
                <Form.Label className="text-white-50 small mb-1 mb-lg-2">Password</Form.Label>
                <Form.Control
                    type="password"
                    placeholder="Masukkan password"
                    className="auth-input"
                />
            </Form.Group>

            <div className="d-flex justify-content-end mb-3 mb-lg-4">
                <a href="/forgot-password" className="auth-link">
                    Lupa password?
                </a>
            </div>

            <button type="submit" className="btn btn-light w-100 auth-button">
                Login
            </button>
        </Form>
    );
}