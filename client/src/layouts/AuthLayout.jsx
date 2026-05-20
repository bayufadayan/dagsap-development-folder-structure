import { Container } from "react-bootstrap";
import loginCover from "../assets/login-cover.jpg";

export default function AuthLayout({ title, description, children }) {
    return (
        <Container
            fluid
            className="auth-shell min-vh-100 d-flex align-items-center justify-content-center p-2 p-md-3 p-lg-4"
        >
            <div className="auth-card row g-0 overflow-hidden shadow-lg w-100">
                <div className="col-lg-6 auth-visual d-none d-lg-block">
                    <img
                        src={loginCover}
                        alt="Login Cover"
                        className="auth-visual-image w-100 h-100"
                    />
                </div>

                <div className="col-lg-6 d-flex align-items-center">
                    <div className="auth-content w-100 p-3 p-md-4 p-lg-5">
                        <h2 className="font-heading fw-bold text-white mb-2 mb-lg-3 auth-title">
                            {title}
                        </h2>

                        <p className="text-white-50 mb-3 mb-lg-4 auth-description">
                            {description}
                        </p>

                        {children}
                    </div>
                </div>
            </div>
        </Container>
    );
}
